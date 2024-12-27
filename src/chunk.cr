require "./block"
require "./chunk_pos"
require "./local_pos"

class Woozy::Chunk
  BitSize = 5
  BitMask = Size - 1
  Size    = 1 << BitSize
  Area    = Size * Size
  Volume  = Size * Size * Size

  getter position : ChunkPos
  getter block_palette : Hash(UInt16, Block)
  getter block_ids : Array(UInt16)

  def initialize(@position, default_block : Block)
    @block_palette = Hash(UInt16, Block).new
    @block_palette[0] = default_block
    @block_ids = Array(UInt16).new(Volume, 0)
  end

  def initialize(@position, @block_palette, @block_ids)
  end

  def set_block(position : LocalPos, block : Block) : Nil
    raise "Position out of bounds" unless position.valid?

    if key = @block_palette.key_for?(block)
      @block_ids[position.index] = key
    else
      key = @block_palette.size.to_u16
      @block_palette[key] = block
      @block_ids[position.index] = key
    end
  end

  def get_block(position : LocalPos) : Block
    raise "Position out of bounds" unless position.valid?

    key = @block_ids[position.index]
    block = @block_palette[key]
  end
end
