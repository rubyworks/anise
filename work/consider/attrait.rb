
#   class C
#     attr :x, :default=>10
#
#     attr :y do
#       inherit true
#       default 20
#       write { |x| x.to_s }
#     end
#   end
#
#   a = C.new
#   a.x  #=> 10
#   a.y  #=> "20"
#
class Attribute

  #
  def initialize(base, name, options={}, &block)
    @base = base
    @name = name

    options.each do |k,v|
      send("#{k}=", v)
    end

    DSL.new(self).instance_eval(&block) if block
  end

  #
  def base
    @base
  end

  #
  def name
    @name
  end

  #
  attr_accessor :default

  #
  attr_accessor :inherit

  #
  def write
    @write
  end

  #
  def write=(procedure)
    @write = procedure.to_proc
  end

  #
  def build
    build_initializer
    build_reader
    build_writer
    build_query
  end

  #
  def build_initializer
    name     = name()
    default  = default()
    if inherit
      base.module_eval do
        define_method("#{ name }!") do
          value = self.class.__send__(name) rescue default
          __send__("#{ name }=", value)
        end
      end
    else
      base.module_eval do
        define_method("#{ name }!") do
          #p default
          __send__("#{ name }=", default)
        end
      end
    end
  end

  #
  def build_reader
    name = name()
    base.module_eval %{
      def #{name}
        #{name}! unless instance_variable_defined?("@#{name}")
        @#{name}
      end
    }
  end

  #
  def build_writer
    name  = name()
    write = write()
    if write
      base.module_eval do
        define_method("#{name}=", &write)
      end
    else
      base.module_eval %{
        def #{name}=x
          @#{name}=x
        end
      }
    end
  end

  #
  def build_query
    name = name()
    base.module_eval %{
      def #{name}?
        #{name}
      end
    }   
  end

  #
  class DSL

    def initialize(attribute)
      @attribute = attribute
    end

    def default(value)
      @attribute.default = value
    end

    def inherit(flag)
      @attribute.inherit = flag
    end

    def write(&block)
      @attribute.write = block
    end

  end

end


class Module
  def attr(name, ann={}, &block)
    Attribute.new(self, name, ann, &block).build
  end
end

