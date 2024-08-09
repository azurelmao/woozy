require "colorize"
require "log"

struct Woozy::Format
  extend Log::Formatter

  def self.format(entry : Log::Entry, io : IO)
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

    severity = severity.to_s

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
  end
end
