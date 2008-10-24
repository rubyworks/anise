require 'anise/annotator'

include Anise::Annotator

class Test_Annotator_Toplevel < Test::Unit::TestCase

  class X
    annotator :req

    req 'r'

    def a ; "a"; end

    req 's'

    attr :b
  end

  def test_annotated
    assert_equal( {:req=>['r']}, X.ann(:a) )
  end

  def test_annotated
    assert_equal( {:req=>['s']}, X.ann(:b) )
  end

end

#annotator :req  # THIS DOES NOT WORK :(

