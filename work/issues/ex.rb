require 'facets/toplevel'

puts "-----------------------------------"

module Foo

  def self.included(base)
p base
    base.extend Self
  end

  module Self

    def make_module_method(name)
      (class << self; self; end).module_eval do
        define_method(name) do |*args|
          "..."
        end
      end
    end

  end

end

p TOPLEVEL.methods.sort

class Bar
  include Foo
  make_module_method('g')
  puts g
end

include Foo
make_module_method('f')
puts f

class Object
  include Foo
  make_module_method('f')
  puts f
end
