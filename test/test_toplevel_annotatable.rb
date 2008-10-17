=begin
require 'annotable'
require 'test/unit'

include Annotatable

annotation :req

class Test_Annotatable < Test::Unit::TestCase

  annotation :req

  req 'r'

  def a
    "a"
  end

  def test_annotated
    assert_equal( {:req=>['r']}, self.class.ann(:a) )
  end

  req 's'

  attr :b

  def test_annotated
    assert_equal( {:req=>['s']}, self.class.ann(:b) )
  end

end
=end
