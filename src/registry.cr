module Woozy
  struct Identifier
    def_hash @namespace, @local

    def initialize(@namespace : String, @local : String)
    end
  end

  struct Namespace
    def self.for(namespace : String)
      Namespace.new(namespace)
    end

    def initialize(@namespace : String)
    end

    def of(local : String)
      Identifier.new(@namespace, local)
    end
  end

  struct Registry(T)
    @item_to_name = Hash(T, Identifier).new
    @name_to_item = Hash(Identifier, T).new

    def register(item : T, *, as name : Identifier)
      item.idx = @name_to_item.size.to_u
      @item_to_name[item] = name
      @name_to_item[name] = item
    end
  end
end
