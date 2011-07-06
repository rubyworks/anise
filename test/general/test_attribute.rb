require 'anise/attribute'

Test.case Anise::Attribute do

  concern "general" do

    cX = Class.new do
      include Anise::Attribute
      attr :q
      attr :a, :x => 1
    end

    test "attr :a" do
      cX.ann(:a) == {:x=>1}
    end

  end

  concern "attr" do

    cA = Class.new do
      include Anise::Attribute
      attr :x, :cast=>"to_s"
    end

    test do
      cA.ann(:x,:cast) == "to_s"
    end

  end

  concern "attr_accessor" do

    cA = Class.new do
      include Anise::Attribute
      attr_accessor :x, :cast=>"to_s"
    end

    test do
      a = cA.new
      r = cA.instance_attributes - [:taguri]
      r == [:x]
    end

  end

end

