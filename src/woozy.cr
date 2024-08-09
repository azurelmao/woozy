require "socket"
require "openssl"
require "./**"

module Woozy
  Id = Namespace.for("woozy")

  Log.setup do |log|
    dispatcher = Log::DispatchMode::Sync
    backend = Log::IOBackend.new(dispatcher: dispatcher, formatter: Format)

    log.bind "*", :trace, backend
  end

  def self.set_terminal_mode : Nil
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

  def self.parse_config_value(value : String)
    case value
    when "true" then true
    when "false" then false
    when .to_i? then value.to_i
    when .to_f? then value.to_f
    else
      nil
    end
  end

  struct Packet
    MaxSize = 64

    def to_slice : Bytes
      self.timestamp = Time.utc.to_unix_f
      self.to_protobuf.to_slice
    end

    def self.from_bytes(bytes : Bytes) : Packet
      Packet.from_protobuf(IO::Memory.new(bytes))
    end

    {% begin %}
    {% packets = ::Protobuf::Message.includers.select { |t| t.name.starts_with?("Woozy") && t.name.stringify != "Woozy::Packet" } %}

    alias Packets = Union({{packets.splat}})

    {% for packet in packets %}
      def self.new(packet : {{packet.id}})
        Packet.new {{packet.name.split("::").last.underscore.id}}: packet
      end
    {% end %}
    {% end %}
  end
end

class TCPSocket
  def send(packet : Woozy::Packet::Packets)
    self.send(Woozy::Packet.new(packet).to_slice)
  end
end

class OpenSSL::SSL::Socket::Server
  def write(packet : Woozy::Packet::Packets)
    self.write(Woozy::Packet.new(packet).to_slice)
  end
end

class OpenSSL::SSL::Socket::Client
  def write(packet : Woozy::Packet::Packets)
    self.write(Woozy::Packet.new(packet).to_slice)
  end
end
