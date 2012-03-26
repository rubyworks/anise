testcase Anise::AnnotatedMethods do

  cX = Class.new do
    extend Anise::AnnotatedMethods

    def self.req(str)
      method_annotation(:req=>str)
    end

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

