testcase Anise::Annotative::Attributes do

  context "general" do

    cX = Class.new do
      extend Anise::Annotative::Attributes
      attr :q
      attr :a, :x => 1
    end

    test "attr :a" do
      cX.ann(:a) == {:x=>1}
    end

  end

  context "attr" do

    cA = Class.new do
      extend Anise::Annotative::Attributes
      attr :x, :cast=>"to_s"
    end

    test do
      cA.ann(:x,:cast) == "to_s"
    end

  end

  context "attr_accessor" do

    cA = Class.new do
      extend Anise::Annotative::Attributes
      attr_accessor :x, :cast=>"to_s"
    end

    test do
      a = cA.new
      r = cA.instance_attributes - [:taguri]
      r == [:x]
    end

  end

end

