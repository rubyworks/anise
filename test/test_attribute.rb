require 'anise/attributes'

class Test_Attribute < Test::Unit::TestCase

  include Anise::Annotatable::Attributes

  attr :q

  attr :a, :x => 1

  def test_attr_a
    assert_equal( {:x=>1}, self.class.ann(:a) )
  end

end

