require "socket"
require "openssl"
require "./**"

module Woozy
  class ChannelBackend < Log::Backend
    def initialize(dispatch_mode : Log::DispatchMode, @log_channel : Channel(Log::Entry))
      @dispatcher = Log::Dispatcher.for(dispatch_mode)
    end

    def write(entry : Log::Entry)
      @log_channel.send(entry)
    end
  end

  def self.setup_logs(log_channel : Channel(Log::Entry)) : Nil
    Log.setup do |log|
      dispatch_mode = Log::DispatchMode::Async
      backend = ChannelBackend.new(dispatch_mode, log_channel)

      log.bind "*", :trace, backend
    end
  end

  def self.setup_terminal_mode : Nil
    before = Crystal::System::FileDescriptor.tcgetattr STDIN.fd
    mode = before
    mode.c_lflag &= ~LibC::ICANON
    mode.c_lflag &= ~LibC::ECHO
    mode.c_lflag &= ~LibC::ISIG

    at_exit do
      Crystal::System::FileDescriptor.tcsetattr(STDIN.fd, LibC::TCSANOW, pointerof(before))
    end

    if Crystal::System::FileDescriptor.tcsetattr(STDIN.fd, LibC::TCSANOW, pointerof(mode)) != 0
      raise IO::Error.from_errno "tcsetattr"
    end
  end

  def self.valid_username?(username : String) : Bool
    if username.size > 32 || username.size < 3
      return false
    end

    first_char = username[0]
    unless first_char.ascii_letter? || first_char == '_'
      return false
    end

    username[1..].each_char do |char|
      unless char.ascii_alphanumeric?
        return false
      end
    end

    true
  end

  def self.highlight_error(object)
    object.colorize(:red).underline.italic
  end
end

class TCPSocket
  def send(packet : Woozy::Packet)
    self.send(packet.to_slice)
  end
end

class OpenSSL::SSL::Socket::Server
  def write(packet : Woozy::Packet)
    self.write(packet.to_slice)
  end
end

class OpenSSL::SSL::Socket::Client
  def write(packet : Woozy::Packet)
    self.write(packet.to_slice)
  end
end
