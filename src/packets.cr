require "./packet"

packet Woozy::ClientHandshakePacket, 1, {username, :string}, {password, :string}
packet Woozy::ServerHandshakePacket, 2
packet Woozy::ClientDisconnectPacket, 3
packet Woozy::ServerDisconnectPacket, 4, {cause, :string}
packet Woozy::ClientBroadcastMessagePacket, 5, {message, :string}
packet Woozy::ServerBroadcastMessagePacket, 6, {sender, :string}, {message, :string}
packet Woozy::ClientPrivateMessagePacket, 7, {recipient, :string}, {message, :string}
packet Woozy::ServerPrivateMessagePacket, 8, {sender, :string}, {message, :string}
packet Woozy::ServerPrivateMessageSuccessPacket, 9, {recipient, :string}, {message, :string}, {success, :bool}
packet Woozy::ClientChunkPacket, 10, {x, :int32}, {y, :int32}, {z, :int32}
packet Woozy::ServerChunkPacket, 11, {x, :int32}, {y, :int32}, {z, :int32}, {block_palette, :map, :uint16, :string}, {block_ids, :array[32768], :uint16}
