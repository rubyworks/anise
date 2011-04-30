require 'anise/annotator'

class Test_Annotator < Test::Unit::TestCase

  class X
    include Anise::Annotator

    annotator :req

    req 'r'
    def a ; "a"; end

    req 'x', 'y'
    attr :b
  end

  def test_annotated
    assert_equal( {:req=>'r'}, X.ann(:a) )
  end

  def test_annotated
    assert_equal( {:req=>['x','y']}, X.ann(:b) )
  end

end

