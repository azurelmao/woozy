alias Woozy::BlockIdx = UInt32

struct Woozy::Block
  getter index : BlockIdx
  @state : UInt32

  def initialize(@index, @state = 0)
  end

  def []=(offset : UInt32, value : UInt32) : Nil
    @state |= (value << offset)
  end

  def [](offset : UInt32, width : UInt32) : UInt32
    (@state >> offset) & width
  end
end
