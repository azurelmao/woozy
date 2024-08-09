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
      optional :server_broadcast_message_packet, ServerBroadcastMessagePacket, 6
      optional :client_broadcast_message_packet, ClientBroadcastMessagePacket, 7
      optional :server_private_message_packet, ServerPrivateMessagePacket, 8
      optional :client_private_message_packet, ClientPrivateMessagePacket, 9
      optional :timestamp, :double, 1
    end
  end
  
  struct ClientHandshakePacket
    include ::Protobuf::Message
    
    contract_of "proto2" do
      optional :username, :string, 1
      optional :password, :string, 2
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
  
  struct ServerBroadcastMessagePacket
    include ::Protobuf::Message
    
    contract_of "proto2" do
      optional :sender, :string, 1
      optional :message, :string, 2
    end
  end
  
  struct ClientBroadcastMessagePacket
    include ::Protobuf::Message
    
    contract_of "proto2" do
      optional :message, :string, 1
    end
  end
  
  struct ServerPrivateMessagePacket
    include ::Protobuf::Message
    
    contract_of "proto2" do
      optional :sender, :string, 1
      optional :message, :string, 2
    end
  end
  
  struct ClientPrivateMessagePacket
    include ::Protobuf::Message
    
    contract_of "proto2" do
      optional :recipient, :string, 1
      optional :message, :string, 2
    end
  end
  end
