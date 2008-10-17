require 'anise/annotatable'

class Test_Annotatable < Test::Unit::TestCase

  include Anise::Annotatable

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

