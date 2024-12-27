class Woozy::ConsoleInputActor
  def initialize(@stop_channel : Channel(Nil), @command_channel : Channel(Command), @change_channel : Channel(Change))
    @history = Array(String).new
    @history_index = 0
    @input = Array(Char).new
    @cursor = 0
  end

  record Change, input : String, cursor : Int32

  def start : Nil
    bytes = Bytes.new(6)
    loop do
      bytes_read = STDIN.read(bytes)

      chars = Slice(Char).new(bytes_read, '\0')
      bytes_read.times do |i|
        chars[i] = bytes[i].chr
      end

      key = self.handle_chars(chars)
      next unless key

      self.handle_key(key)

      spawn @change_channel.send(Change.new(@input.join, @cursor))
    end
  end

  def handle_chars(chars : Slice(Char)) : Key?
    case char0 = chars[0]
    when '\u{3}', '\u{4}'
      return Key::Stop.new
    when '\n' # Enter
      return Key::Enter.new
    when '\u{7f}' # Backspace
      return Key::Backspace.new
    when '\e'
      case char1 = chars[1]
      when '['
        case char2 = chars[2]
        when 'A' # Up
          return Key::Up.new
        when 'B' # Down
          return Key::Down.new
        when 'C' # Right
          return Key::Right.new
        when 'D' # Left
          return Key::Left.new
        when '3'
          case char3 = chars[3]
          when '~' # Delete
            return Key::Delete.new
          end
        when '1'
          case char3 = chars[3]
          when ';'
            case char4 = chars[4]
            when '5'
              case char5 = chars[5]
              when 'C' # Ctrl + Right
                return Key::CtrlRight.new
              when 'D' # Ctrl + Left
                return Key::CtrlLeft.new
              end
            end
          end
        end
      end

      return nil
    else
      return Key::Chars.new(chars)
    end
  end

  abstract struct Key
    record Chars < Key, chars : Slice(Char)

    struct Stop < Key; end

    struct Enter < Key; end

    struct Backspace < Key; end

    struct Delete < Key; end

    struct Up < Key; end

    struct Down < Key; end

    struct Right < Key; end

    struct Left < Key; end

    struct CtrlRight < Key; end

    struct CtrlLeft < Key; end
  end

  def handle_key(key : Key) : Nil
    case key
    when Key::Stop
      @stop_channel.send(nil)
    when Key::Enter
      command = @input.join
      @input.clear
      @cursor = 0

      if !command.blank? && !command.empty?
        @history << command
        @history_index = @history.size
        spawn @command_channel.send(Command.new(command.split(' ')))
      end
    when Key::Backspace
      if (index = @cursor - 1) >= 0
        @input.delete_at(index)
        @cursor = Math.max(0, @cursor - 1)
      end
    when Key::Delete
      if (index = @cursor) >= 0 && index < @input.size
        @input.delete_at(index)
      end
    when Key::Up
      unless @history.empty?
        @history_index = Math.max(0, @history_index - 1)
        @input = @history[@history_index].chars
        @cursor = Math.min(@cursor, @input.size)
      end
    when Key::Down
      unless @history.empty?
        if @history_index + 1 < @history.size
          @history_index = Math.min(@history.size - 1, @history_index + 1)
          @input = @history[@history_index].chars
          @cursor = Math.min(@cursor, @input.size)
        else
          @history_index = @history.size
          @input.clear
          @cursor = 0
        end
      end
    when Key::Right
      @cursor = Math.min(@input.size, @cursor + 1)
    when Key::Left
      @cursor = Math.max(0, @cursor - 1)
    when Key::CtrlRight
      iter = @input[@cursor..].each

      first_char = iter.next
      if first_char.is_a? Iterator::Stop
        return
      end

      index = @cursor + 1

      case first_char
      when .whitespace?
        while (char = iter.next) && !char.is_a? Iterator::Stop
          unless char.whitespace?
            break
          end
          index += 1
        end
      else
        while (char = iter.next) && !char.is_a? Iterator::Stop
          if char.whitespace?
            break
          end
          index += 1
        end
      end

      @cursor = index
    when Key::CtrlLeft
      iter = @input[0...@cursor].reverse_each

      first_char = iter.next
      if first_char.is_a? Iterator::Stop
        return
      end

      index = @cursor - 1

      case first_char
      when .whitespace?
        while (char = iter.next) && !char.is_a? Iterator::Stop
          unless char.whitespace?
            break
          end
          index -= 1
        end
      else
        while (char = iter.next) && !char.is_a? Iterator::Stop
          if char.whitespace?
            break
          end
          index -= 1
        end
      end

      @cursor = index
    when Key::Chars
      key.chars.each do |char|
        @input.insert(@cursor, char)
        @cursor = Math.min(@input.size, @cursor + 1)
      end
    end
  end
end
