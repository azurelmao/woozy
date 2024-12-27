abstract struct Woozy::Pos3
  @vec : StaticArray(Int32, 3)

  def_hash x, y, z

  def initialize(x : Int32, y : Int32, z : Int32)
    @vec = StaticArray[x, y, z]
  end

  def x : Int32
    @vec[0]
  end

  def y : Int32
    @vec[1]
  end

  def z : Int32
    @vec[2]
  end

  def splat : {Int32, Int32, Int32}
    {x, y, z}
  end

  def splat_f32 : {Float32, Float32, Float32}
    {x.to_f32, y.to_f32, z.to_f32}
  end

  def - : self
    self.class.new(-x, -y, -z)
  end

  {% for operator in ["+", "-", "*", "**", "/", "//", "%"] %}
    def {{operator.id}}(other : self) : self
      self.class.new(
        x {{operator.id}} other.x,
        y {{operator.id}} other.y,
        z {{operator.id}} other.z
      )
    end
  {% end %}

  {% for operator in ["+", "-", "*", "**", "/", "//", "%"] %}
    def {{operator.id}}(value : Int32) : self
      self.class.new(
        x {{operator.id}} value,
        y {{operator.id}} value,
        z {{operator.id}} value
      )
    end
  {% end %}

  def to(other : self, & : self ->) : Nil
    x.to other.x do |x|
      y.to other.y do |y|
        z.to other.z do |z|
          yield self.class.new(x, y, z)
        end
      end
    end
  end
end

abstract struct Woozy::Pos2
  @vec : StaticArray(Int32, 2)

  def_hash x, z

  def initialize(x : Int32, z : Int32)
    @vec = StaticArray[x, z]
  end

  def x : Int32
    @vec[0]
  end

  def z : Int32
    @vec[1]
  end

  def - : self
    self.class.new(-x, -z)
  end

  {% for operator in ["+", "-", "*", "**", "/", "//", "%"] %}
    def {{operator.id}}(other : self) : self
      self.class.new(
        x {{operator.id}} other.x,
        z {{operator.id}} other.z
      )
    end
  {% end %}

  {% for operator in ["+", "-", "*", "**", "/", "//", "%"] %}
    def {{operator.id}}(value : Int32) : self
      self.class.new(
        x {{operator.id}} value,
        z {{operator.id}} value
      )
    end
  {% end %}

  def to(other : self, & : self ->) : Nil
    x.to other.x do |x|
      z.to other.z do |z|
        yield self.class.new(x, z)
      end
    end
  end
end

struct Int
  {% for operator in ["+", "-", "*", "**", "/", "//", "%"] %}
    def {{operator.id}}(pos3 : Woozy::Pos3) : Woozy::Pos3
      pos3.class.new(
        self {{operator.id}} pos3.x,
        self {{operator.id}} pos3.y,
        self {{operator.id}} pos3.z
      )
    end

    def {{operator.id}}(pos2 : Woozy::Pos2) : Woozy::Pos2
      pos2.class.new(
        self {{operator.id}} pos2.x,
        self {{operator.id}} pos2.z
      )
    end
  {% end %}
end
