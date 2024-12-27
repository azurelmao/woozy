require "./pos3"

# Represents a local position of a block, relative to the (-x, -y, -z) corner of the chunk it resides in
struct Woozy::LocalPos < Woozy::Pos3
  def valid? : Bool
    Chunk::Size > x >= 0 && Chunk::Size > y >= 0 && Chunk::Size > z >= 0
  end

  def index : Int32
    y * Chunk::Size * Chunk::Size + x * Chunk::Size + z
  end

  def to_xz : LocalPosXZ
    LocalPosXZ.new(x, z)
  end
end

struct Woozy::LocalPosXZ < Woozy::Pos2
  def valid? : Bool
    Chunk::Size > x >= 0 && Chunk::Size > z >= 0
  end

  def index : Int32
    x * Chunk::Size + z
  end
end
