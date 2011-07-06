require 'anise/method'

Test.case "Anise::Method" do

  cX = Class.new do
    include Anise::Method

    method_annotator :req

    req 'r'
    def a ; "a"; end

    req 'x', 'y'
    attr :b
  end

  test do |a, k|
    cX.ann(a, k)
  end

  ok :a, :req => 'r'
  ok :b, :req => ['x','y']

  test do |a|
    cX.ann(a)
  end

  ok :a => {:req=>'r'}
  ok :b => {:req=>['x','y']}

end

