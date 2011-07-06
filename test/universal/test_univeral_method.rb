require 'anise/universal/method'

Test.case "Universal Method Annoations" do

  cX = Class.new do
    method_annotator :req

    req 'r'
    def a ; "a"; end

    req 's', 't'
    attr :b
  end

  test "method #a is annotated"
    X.ann(:a) == {:req=>'r'}
  end

  test "attribute #b is annotated" do
    X.ann(:b) == {:req=>['s','t']}
  end

end

#annotation :req  # THIS DOES NOT WORK :(

