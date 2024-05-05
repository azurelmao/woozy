class Chronicle
  alias Record = Array(Char)

  def initialize
    @records = Array(Record).new
    @records << Record.new
    @record_index = 0
    @cursor_index = 0
  end

  def cursor_index
    @cursor_index
  end

  def current_record : Record
    @records[@record_index]
  end

  def last_record=(record : Record)
    @records[self.last_record_index] = record
  end

  def last_record_index : Int32
    @records.size - 1
  end

  def on_destructive_action : Nil
    if @record_index < self.last_record_index
      self.last_record = self.current_record.clone
      @record_index = self.last_record_index
    end
  end

  def move_to_next_record : Nil
     if @record_index < self.last_record_index
       @record_index += 1
       @cursor_index = self.current_record.size if @cursor_index > self.current_record.size
     end
  end

  def move_to_prev_record : Nil
    if @record_index > 0
      @record_index -= 1
      @cursor_index = self.current_record.size if @cursor_index > self.current_record.size
    end
  end

  def move_cursor_right : Nil
    @cursor_index += 1 if @cursor_index < self.current_record.size
  end

  def move_cursor_left : Nil
    @cursor_index -= 1 if @cursor_index > 0
  end

  def delete_current_char : Nil
    if @cursor_index < self.current_record.size
      self.on_destructive_action

      if self.current_record[@cursor_index]?
        self.current_record.delete_at(@cursor_index)
      else
        self.current_record.pop?
      end
    end
  end

  def delete_prev_char : Nil
    if @cursor_index > 0
      self.on_destructive_action

      if self.current_record[@cursor_index - 1]?
        self.current_record.delete_at(@cursor_index - 1)
      else
        self.current_record.pop?
      end

      @cursor_index -= 1
    end
  end

  def write_at_cursor(char : Char) : Nil
    self.on_destructive_action

    if self.current_record[@cursor_index]?
      self.current_record.insert(@cursor_index, char)
    else
      self.current_record << char
    end

    @cursor_index += 1
  end

  def send : String
    input = self.current_record.join

    unless self.current_record.empty?
      @records << Record.new
      @record_index = self.last_record_index
      @cursor_index = 0
    end

    input
  end
end
