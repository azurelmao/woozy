class Woozy::SimpleConfig(T)
  def initialize(@path : String, default_config, & : String -> T?)
    @bad_entries = Array(String).new
    @config = Hash(String, T).new
    default_config.each do |(key, value)|
      @config[key] = value
    end

    unless File.exists?(@path)
      contents = String.build do |string|
        default_config.each do |(key, value)|
          string << key
          string << '='
          string << value
          string << '\n'
        end
      end
      File.write(@path, contents)
    end

    File.read(@path).each_line do |line|
      data = line.strip.split('=')

      if data.size != 2
        Log.error { "Incorrect format of config entry in #{@path}, ignoring entry `#{line}`" }
        @bad_entries << line
        next
      end

      key, value = data

      key = key.strip
      value = value.strip

      if @config.has_key?(key)
        parsed_value = yield value
        if !parsed_value.nil? && parsed_value.class == @config[key].class
          @config[key] = parsed_value
        else
          Log.error { "Invalid value `#{value}` for config key `#{key}` in #{@path}" }
          @bad_entries << line
        end
      else
        Log.error { "Unknown config key `#{key}` in #{@path}" }
        @bad_entries << line
      end
    end
  end

  def write : Nil
    contents = String.build do |string|
      @config.each do |(key, value)|
        string << key
        string << '='
        string << value
        string << '\n'
      end

      @bad_entries.each do |bad_entry|
        string << bad_entry
        string << '\n'
      end
    end

    File.write(@path, contents)
  end

  delegate :[], :[]=, to: @config
end
