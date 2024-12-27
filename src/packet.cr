module Woozy::PacketImpl
  abstract def read(bytes : Bytes) : Packet?
  abstract def id : UInt8
end

abstract struct Woozy::Packet
  extend Woozy::PacketImpl

  abstract def size : Int32
  abstract def write(bytes : Bytes)

  DefaultSize = 256
  HeaderSize = 5 # sizeof(UInt8) + sizeof(Int32)

  macro finished
    {% begin %}
      IdToType = {
      {% for packet in Woozy::Packet.all_subclasses %}
        {{packet.name}}::Id => {{packet.name}},
      {% end %}
      } of UInt8 => Woozy::Packet.class
    {% end %}
  end

  def to_slice : Bytes
    size = self.size
    bytes = Bytes.new(size + HeaderSize)

    # Write header
    bytes[0] = self.class.id
    IO::ByteFormat::LittleEndian.encode(size, bytes[sizeof(UInt8)...HeaderSize])

    self.write(bytes[HeaderSize..])
    bytes
  end

  def self.header_from_bytes(bytes : Bytes) : {UInt8, Int32}
    id = bytes[0]
    size = IO::ByteFormat::LittleEndian.decode(Int32, bytes[sizeof(UInt8)...HeaderSize])
    {id, size}
  end

  def self.from_id(id : UInt8, bytes : Bytes) : Packet?
    type = IdToType[id]
    type.read(bytes)
  end
end

macro packet(packet_name, id, *args)
  struct {{packet_name}} < Woozy::Packet
    Id = {{id}}_u8

  {%
    sizes = {} of MacroId => NumberLiteral
    types = {} of MacroId => TypeNode

    args.each do |arg|
      unless arg.is_a? TupleLiteral
        raise "Unexpected format #{arg}"
      end

      name = arg[0]

      if arg[1].is_a? Call
        size = arg[1].args[0]

        if arg[1].receiver == :array
          generic_type = if arg[2].is_a? SymbolLiteral
                           if arg[2] == :string
                             String
                           elsif arg[2] == :uint8
                             UInt8
                           elsif arg[2] == :int8
                             Int8
                           elsif arg[2] == :uint16
                             UInt16
                           elsif arg[2] == :int16
                             Int16
                           elsif arg[2] == :uint32
                             UInt32
                           elsif arg[2] == :int32
                             Int32
                           elsif arg[2] == :uint64
                             UInt64
                           elsif arg[2] == :int64
                             Int64
                           elsif arg[2] == :float32
                             Float32
                           elsif arg[2] == :float64
                             Float64
                           else
                             raise "Unexpected format #{arg[2]}"
                           end
                         else
                           raise "Unexpected format #{arg[2]}"
                         end

          sizes[name] = size
          types[name] = parse_type("Array(#{generic_type})").resolve
        elsif arg[1].receiver == :map
          generic_type1 = if arg[2].is_a? SymbolLiteral
                            if arg[2] == :string
                              String
                            elsif arg[2] == :uint8
                              UInt8
                            elsif arg[2] == :int8
                              Int8
                            elsif arg[2] == :uint16
                              UInt16
                            elsif arg[2] == :int16
                              Int16
                            elsif arg[2] == :uint32
                              UInt32
                            elsif arg[2] == :int32
                              Int32
                            elsif arg[2] == :uint64
                              UInt64
                            elsif arg[2] == :int64
                              Int64
                            elsif arg[2] == :float32
                              Float32
                            elsif arg[2] == :float64
                              Float64
                            else
                              raise "Unexpected format #{arg[2]}"
                            end
                          else
                            raise "Unexpected format #{arg[2]}"
                          end

          generic_type2 = if arg[3].is_a? SymbolLiteral
                            if arg[3] == :string
                              String
                            elsif arg[3] == :uint8
                              UInt8
                            elsif arg[3] == :int8
                              Int8
                            elsif arg[3] == :uint16
                              UInt16
                            elsif arg[3] == :int16
                              Int16
                            elsif arg[3] == :uint32
                              UInt32
                            elsif arg[3] == :int32
                              Int32
                            elsif arg[3] == :uint64
                              UInt64
                            elsif arg[3] == :int64
                              Int64
                            elsif arg[3] == :float32
                              Float32
                            elsif arg[3] == :float64
                              Float64
                            else
                              raise "Unexpected format #{arg[3]}"
                            end
                          else
                            raise "Unexpected format #{arg[3]}"
                          end

          sizes[name] = size
          types[name] = parse_type("Hash(#{generic_type1}, #{generic_type2})").resolve
        end
      elsif arg[1].is_a? SymbolLiteral
        if arg[1] == :array
          generic_type = if arg[2].is_a? SymbolLiteral
                           if arg[2] == :string
                             String
                           elsif arg[2] == :uint8
                             UInt8
                           elsif arg[2] == :int8
                             Int8
                           elsif arg[2] == :uint16
                             UInt16
                           elsif arg[2] == :int16
                             Int16
                           elsif arg[2] == :uint32
                             UInt32
                           elsif arg[2] == :int32
                             Int32
                           elsif arg[2] == :uint64
                             UInt64
                           elsif arg[2] == :int64
                             Int64
                           elsif arg[2] == :float32
                             Float32
                           elsif arg[2] == :float64
                             Float64
                           else
                             raise "Unexpected format #{arg[2]}"
                           end
                         else
                           raise "Unexpected format #{arg[2]}"
                         end

          types[name] = parse_type("Array(#{generic_type})").resolve
        elsif arg[1] == :map
          generic_type1 = if arg[2].is_a? SymbolLiteral
                            if arg[2] == :string
                              String
                            elsif arg[2] == :uint8
                              UInt8
                            elsif arg[2] == :int8
                              Int8
                            elsif arg[2] == :uint16
                              UInt16
                            elsif arg[2] == :int16
                              Int16
                            elsif arg[2] == :uint32
                              UInt32
                            elsif arg[2] == :int32
                              Int32
                            elsif arg[2] == :uint64
                              UInt64
                            elsif arg[2] == :int64
                              Int64
                            elsif arg[2] == :float32
                              Float32
                            elsif arg[2] == :float64
                              Float64
                            else
                              raise "Unexpected format #{arg[2]}"
                            end
                          else
                            raise "Unexpected format #{arg[2]}"
                          end

          generic_type2 = if arg[3].is_a? SymbolLiteral
                            if arg[3] == :string
                              String
                            elsif arg[3] == :uint8
                              UInt8
                            elsif arg[3] == :int8
                              Int8
                            elsif arg[3] == :uint16
                              UInt16
                            elsif arg[3] == :int16
                              Int16
                            elsif arg[3] == :uint32
                              UInt32
                            elsif arg[3] == :int32
                              Int32
                            elsif arg[3] == :uint64
                              UInt64
                            elsif arg[3] == :int64
                              Int64
                            elsif arg[3] == :float32
                              Float32
                            elsif arg[3] == :float64
                              Float64
                            else
                              raise "Unexpected format #{arg[3]}"
                            end
                          else
                            raise "Unexpected format #{arg[3]}"
                          end

          types[name] = parse_type("Hash(#{generic_type1}, #{generic_type2})").resolve
        else
          type = if arg[1] == :string
                   String
                 elsif arg[1] == :bool
                   Bool
                 elsif arg[1] == :uint8
                   UInt8
                 elsif arg[1] == :int8
                   Int8
                 elsif arg[1] == :uint16
                   UInt16
                 elsif arg[1] == :int16
                   Int16
                 elsif arg[1] == :uint32
                   UInt32
                 elsif arg[1] == :int32
                   Int32
                 elsif arg[1] == :uint64
                   UInt64
                 elsif arg[1] == :int64
                   Int64
                 elsif arg[1] == :float32
                   Float32
                 elsif arg[1] == :float64
                   Float64
                 else
                   raise "Unexpected format #{arg[1]}"
                 end

          types[name] = type
        end
      else
        raise "Unexpected format #{arg[1]}"
      end
    end
  %}

  {% for entry in types.to_a %}
  	{% name = entry[0] %}
  	{% type = entry[1] %}
    getter {{name}} : {{type}}
  {% end %}

    def initialize(
  {% for entry in types.to_a %}
  	{% name = entry[0] %}
  	{% type = entry[1] %}
    @{{name}} : {{type}},
  {% end %}
    )
    end

    def self.id : UInt8
      Id
    end

    def size : Int32
      size = 0
{% for entry in types.to_a %}
  {% name = entry[0] %}
  {% type = entry[1] %}
  {% if type <= String %}
      size += @{{name}}.bytesize + 1 # 1 byte for the string length
  {% elsif type <= Array %}
    {% generic_type = type.type_vars[0] %}

    {% unless sizes[name] %}
      size += sizeof(Int32)
    {% end %}

    {% if generic_type <= String %}
      @{{name}}.each do |str|
        size += str.bytesize + 1 # 1 byte for the string length
      end
    {% else %}
      size += @{{name}}.size * sizeof({{generic_type}})
    {% end %}
  {% elsif type <= Hash %}
    {% generic_type1 = type.type_vars[0] %}
    {% generic_type2 = type.type_vars[1] %}

    {% unless sizes[name] %}
      size += sizeof(Int32)
    {% end %}

    {% if generic_type1 <= String %}
      @{{name}}.each_key do |str|
        size += str.bytesize + 1 # 1 byte for the string length
      end
    {% else %}
      size += {{name}}.size * sizeof({{generic_type1}})
    {% end %}

    {% if generic_type2 <= String %}
      @{{name}}.each_value do |str|
        size += str.bytesize + 1 # 1 byte for the string length
      end
    {% else %}
      size += @{{name}}.size * sizeof({{generic_type2}})
    {% end %}
  {% else %}
      size += sizeof({{type}})
  {% end %}
{% end %}
      size
    end

    def write(bytes : Bytes)
      index = 0
{% for entry in types.to_a %}
  {% name = entry[0] %}
  {% type = entry[1] %}
  {% if type <= String %}
    {% generic_size = "@#{name}.bytesize".id %}
      bytes[index] = {{generic_size}}.to_u8
      index += 1
      bytes[index...(index + {{generic_size}})].copy_from(@{{name}}.to_slice)
      index += {{generic_size}}
  {% elsif type <= Array %}
    {% generic_type = type.type_vars[0] %}

    {% unless sizes[name] %}
      IO::ByteFormat::LittleEndian.encode(@{{name}}.size, bytes[index...(index + sizeof(Int32))])
      index += sizeof(Int32)
    {% end %}

    {% if generic_type.resolve <= String %}
      @{{name}}.each do |item|
        %generic_size = item.bytesize
        bytes[index] = %generic_size.to_u8
        index += 1
        bytes[index...(index + %generic_size)].copy_from(item.to_slice)
        index += %generic_size
      end
    {% else %}
      {% generic_size = "sizeof(#{generic_type})".id %}
      @{{name}}.each do |item|
        IO::ByteFormat::LittleEndian.encode(item, bytes[index...(index + {{generic_size}})])
        index += {{generic_size}}
      end
    {% end %}
  {% elsif type <= Hash %}
    {% generic_type1 = type.type_vars[0] %}
    {% generic_type2 = type.type_vars[1] %}

    {% unless sizes[name] %}
      IO::ByteFormat::LittleEndian.encode(@{{name}}.size, bytes[index...(index + sizeof(Int32))])
      index += sizeof(Int32)
    {% end %}

    {% if generic_type1.resolve <= String %}
      @{{name}}.each_key do |key|
        %generic_size1 = key.bytesize
        bytes[index] = %generic_size1.to_u8
        index += 1
        bytes[index...(index + %generic_size1)].copy_from(key.to_slice)
        index += %generic_size1
      end
    {% else %}
      {% generic_size1 = "sizeof(#{generic_type1})".id %}
      @{{name}}.each_key do |key|
        IO::ByteFormat::LittleEndian.encode(key, bytes[index...(index + {{generic_size1}})])
        index += {{generic_size1}}
      end
    {% end %}

    {% if generic_type2.resolve <= String %}
      @{{name}}.each_value do |value|
        %generic_size2 = value.bytesize
        bytes[index] = %generic_size2.to_u8
        index += 1
        bytes[index...(index + %generic_size2)].copy_from(value.to_slice)
        index += %generic_size2
      end
    {% else %}
      {% generic_size2 = "sizeof(#{generic_type2})".id %}
      @{{name}}.each_value do |value|
        IO::ByteFormat::LittleEndian.encode(value, bytes[index...(index + {{generic_size2}})])
        index += {{generic_size2}}
      end
    {% end %}
  {% elsif type <= Bool %}
      bytes[index] = @{{name}}.to_unsafe.to_u8
      index += 1
  {% else %}
    {% size = "sizeof(#{type})".id %}
      IO::ByteFormat::LittleEndian.encode(@{{name}}, bytes[index...(index + {{size}})])
      index += {{size}}
  {% end %}
{% end %}
    end

    def self.read(bytes : Bytes) : self?
      begin
      index = 0
{% for entry in types.to_a %}
  {% name = entry[0] %}
  {% type = entry[1] %}
  {% if type <= String %}
      %size = bytes[index]
      index += 1
      {{name}} = String.new(bytes[index...(index + %size)])
      index += %size
  {% elsif type <= Array %}
    {% generic_type = type.type_vars[0] %}

    {% if size = sizes[name] %}
      %size = {{size}}
    {% else %}
      %size = IO::ByteFormat::LittleEndian.decode(Int32, bytes[index...(index + sizeof(Int32))])
      index += sizeof(Int32)
    {% end %}

    {% if generic_type.resolve <= String %}
      {{name}} = Array(String).new(%size) do |i|
        %generic_size = bytes[index]
        index += 1
        str = String.new(bytes[index...(index + %generic_size)])
        index += %generic_size
        str
      end
    {% else %}
      {% generic_size = "sizeof(#{generic_type})".id %}
      {{name}} = {{type}}.new(%size) do |i|
        n = IO::ByteFormat::LittleEndian.decode({{generic_type}}, bytes[index...(index + {{generic_size}})])
        index += {{generic_size}}
        n
      end
    {% end %}
  {% elsif type <= Hash %}
    {% generic_type1 = type.type_vars[0] %}
    {% generic_type2 = type.type_vars[1] %}

    {% if size = sizes[name] %}
      %size = {{size}}
    {% else %}
      %size = IO::ByteFormat::LittleEndian.decode(Int32, bytes[index...(index + sizeof(Int32))])
      index += sizeof(Int32)
    {% end %}

    {% if generic_type1.resolve <= String %}
      %keys = Array(String).new(%size) do |i|
        %generic_size1 = bytes[index]
        index += 1
        str = String.new(bytes[index...(index + %generic_size1)])
        index += %generic_size1
        str
      end
    {% else %}
      {% generic_size1 = "sizeof(#{generic_type1})".id %}
      %keys = Array({{generic_type1}}).new(%size) do |i|
        n = IO::ByteFormat::LittleEndian.decode({{generic_type1}}, bytes[index...(index + {{generic_size1}})])
        index += {{generic_size1}}
        n
      end
    {% end %}

    {% if generic_type2.resolve <= String %}
      %values = Array(String).new(%size) do |i|
        %generic_size2 = bytes[index]
        index += 1
        str = String.new(bytes[index...(index + %generic_size2)])
        index += %generic_size2
        str
      end
    {% else %}
      {% generic_size2 = "sizeof(#{generic_type2})".id %}
      %values = Array({{generic_type2}}).new(%size) do |i|
        n = IO::ByteFormat::LittleEndian.decode({{generic_type2}}, bytes[index...(index + {{generic_size2}})])
        index += {{generic_size2}}
        n
      end
    {% end %}

      {{name}} = Hash.zip(%keys, %values)
  {% elsif type <= Bool %}
      {{name}} = bytes[index] == 0 ? false : true
      index += 1
  {% else %}
    {% size = "sizeof(#{type})".id %}
      {{name}} = IO::ByteFormat::LittleEndian.decode({{type}}, bytes[index...(index + {{size}})])
      index += {{size}}
  {% end %}
{% end %}

      {{packet_name}}.new(
    {% for name in types.keys %}
        {{name}},
    {% end %}
      )
      rescue ex
        Log.fatal(exception: ex) {""}
        nil
      end
    end
  end
end
