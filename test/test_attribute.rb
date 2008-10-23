require 'anise/attributes'

class Test_Attribute < Test::Unit::TestCase
  class X
    include Anise::Attributes
    attr :q
    attr :a, :x => 1
  end

  def test_attr_a
    assert_equal( {:x=>1}, X.ann(:a) )
  end
end

class TC_Attributes_Using_Attr < Test::Unit::TestCase
  class A
    include Anise::Attributes
    attr :x, :cast=>"to_s"
  end

  def test_01
    assert_equal( "to_s", A.ann(:x,:cast) )
  end
end

class TC_Attributes_Using_Attr_Accessor < Test::Unit::TestCase
  class A
    include Anise::Attributes
    attr_accessor :x, :cast=>"to_s"
  end

  def test_01
    a = A.new
    assert_equal( [:x], A.instance_attributes )
  end
end

