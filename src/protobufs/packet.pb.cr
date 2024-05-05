## Generated from packet.proto for woozy
require "protobuf"

module Woozy
  
  struct Packet
    include ::Protobuf::Message
    
    contract_of "proto2" do
      optional :client_handshake_packet, ClientHandshakePacket, 2
      optional :server_handshake_packet, ServerHandshakePacket, 3
      optional :client_disconnect_packet, ClientDisconnectPacket, 4
      optional :server_disconnect_packet, ServerDisconnectPacket, 5
      optional :client_message_packet, ClientMessagePacket, 6
      optional :timestamp, :double, 1
    end
  end
  
  struct ClientHandshakePacket
    include ::Protobuf::Message
    
    contract_of "proto2" do
      optional :username, :string, 1
    end
  end
  
  struct ServerHandshakePacket
    include ::Protobuf::Message
    
    contract_of "proto2" do
    end
  end
  
  struct ClientDisconnectPacket
    include ::Protobuf::Message
    
    contract_of "proto2" do
      optional :cause, :string, 1
    end
  end
  
  struct ServerDisconnectPacket
    include ::Protobuf::Message
    
    contract_of "proto2" do
      optional :cause, :string, 1
    end
  end
  
  struct ClientMessagePacket
    include ::Protobuf::Message
    
    contract_of "proto2" do
      optional :message, :string, 1
    end
  end
  end
