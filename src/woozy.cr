require "./**"

module Woozy
  Id = Namespace.for("woozy")

  Log.setup do |log|
    dispatcher = Log::DispatchMode::Direct
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

    def self.from_socket(socket : TCPSocket) : Packet?
      begin
        return nil if socket.closed?
        bytes = Bytes.new(Packet::MaxSize)
        socket.receive(bytes)
        Packet.from_bytes(bytes)
      rescue ex : IO::Error
        return nil
      end
    end
  end
end
