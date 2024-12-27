require "colorize"

class Woozy::ConsoleOutputActor
  def initialize(@change_channel : Channel(ConsoleInputActor::Change), @log_channel : Channel(Log::Entry))
    @self_stop_channel = Channel(Nil).new
    @input = ""
    @cursor = 0
  end

  def clear_input(io) : Nil
    io << "\e[2K\r"
  end

  def print_input(io) : Nil
    io << "> #{@input}\r\e[#{2 + @cursor}C"
  end

  def format(io : IO, entry : Log::Entry) : Nil
    label = entry.severity.label

    severity = case entry.severity
               when .trace?  then " #{label} ".colorize(:white).back(:magenta).italic
               when .debug?  then " #{label} ".colorize(:light_cyan)
               when .info?   then " #{label}  "
               when .notice? then " NOTE  ".colorize(:light_yellow)
               when .warn?   then " #{label}  ".colorize(255, 135, 0)
               when .error?  then " #{label} ".colorize(:light_red)
               when .fatal?  then " #{label} ".colorize(:black).back(:red).bold
               end

    io << '['
    io << entry.timestamp.time_of_day
    io << ']'
    io << ' '

    io << severity if severity
    io << ' '
    io << '-'
    io << ' '

    unless entry.source.empty?
      io << entry.source
      io << ':'
      io << ' '
    end

    if exception = entry.exception
      io << exception.message
      io << ' '
      io << '('
      io << exception.class.name
      io << ')'
    else
      io << entry.message
    end

    unless entry.data.empty?
      max_size = 0
      entry.data.each do |(name, _)|
        max_size = Math.max(max_size, name.to_s.size)
      end

      entry.data.each do |(name, value)|
        io << '\n'
        io << '-'
        io << ' '
        unless name.to_s.starts_with?('u') && name.to_s.size == 2 && name.to_s[1].ascii_number?
          io << "#{name}:".to_s.ljust(max_size + 1)
          io << ' '
        end
        io << value
      end
    end

    if exception = entry.exception
      if backtrace = exception.backtrace?
        backtrace.each do |frame|
          io << '\n'
          io << "  from "
          io << frame
        end
      end
    end

    io << '\n'
  end

  def start : Nil
    io = STDOUT

    loop do
      select
      when @self_stop_channel.receive
        self.clear_input(io)
        break
      when change = @change_channel.receive
        @input = change.input
        @cursor = change.cursor
        self.clear_input(io)
        self.print_input(io)
      when entry = @log_channel.receive
        self.clear_input(io)
        self.format(io, entry)
        self.print_input(io)
      end
    end
  end

  def stop : Nil
    @self_stop_channel.send(nil)
  end
end
