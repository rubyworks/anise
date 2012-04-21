testcase Anise::Annotative::Methods do

  cX = Class.new do
    extend Anise::Annotative::Methods

    def self.req(val)
      method_annotation(:req=>val)
    end

    req 'r'
    def a ; "a"; end

    req ['x', 'y']
    attr :b
  end

  test do |a, h|
    h.each do |k, r|
      cX.ann(a, k).assert == r
    end
  end

  ok :a, :req => 'r'
  ok :b, :req => ['x','y']

  test do |h|
    h.each do |a, r|
      cX.ann(a).assert == r
    end
  end

  ok :a => {:req=>'r'}
  ok :b => {:req=>['x','y']}

end

