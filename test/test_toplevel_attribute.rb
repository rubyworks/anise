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

