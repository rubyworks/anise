=begin
require 'annotable/attributes'
require 'test/unit'

include Annotatable::Attributes

$self = self

attr :b, :y => 1

class Test_Attribute_Toplevel < Test::Unit::TestCase

  attr :q

  attr :a, :x => 1

  def test_attr_a
    assert_equal( {:x=>1}, self.class.ann(:a) )
  end

  def test_attr_b
    assert_equal( {:y=>1}, $self.class.ann(:b) )
  end

end
=end

require 'anise/attributes'

include Anise::Annotatable::Attributes

class Test_Attribute < Test::Unit::TestCase
  class X
    attr :q
    attr :a, :x => 1
  end

  def test_attr_a
    assert_equal( {:x=>1}, X.ann(:a) )
  end
end

class TC_Attributes_Using_Attr < Test::Unit::TestCase
  class A
    attr :x, :cast=>"to_s"
  end

  def test_01
    assert_equal( "to_s", A.ann(:x,:cast) )
  end
end

class TC_Attributes_Using_Attr_Accessor < Test::Unit::TestCase
  class A
    attr_accessor :x, :cast=>"to_s"
  end

  def test_01
    a = A.new
    assert_equal( [:x], A.instance_attributes )
  end
end

