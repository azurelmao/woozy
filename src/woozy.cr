require "socket"
require "./**"

module Woozy
  Id = Namespace.for("woozy")

  Log.setup do |log|
    dispatcher = Log::DispatchMode::Sync
    backend = Log::IOBackend.new(dispatcher: dispatcher, formatter: Format)

    log.bind "*", :trace, backend
  end

  struct Packet
    MaxSize = 64

    def to_slice : Bytes
      timestamp = Time.utc.to_unix_f
      to_protobuf.to_slice
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
    send Woozy::Packet.new packet
  end
end
