require 'anise'

Test.case "Integration of Method and Attribute Modules" do

  context "simple co-existence" do

    cX = Class.new do
      include Anise::Method
      include Anise::Attribute
    end

    test "initialize" do
      cX.new
    end

  end

  context "method annotations work" do

    cX = Class.new do
      include Anise::Method
      include Anise::Attribute

      method_annotator :doc

      doc "a-okay captain"
      def x; end
    end

    test "doc is defined for method" do
      cX.ann(:x,:doc) == "a-okay captain"
    end

  end

  context "attribute annotations work" do

    cX = Class.new do
      include Anise::Method
      include Anise::Attribute

      attr :x, :doc => "still okay"
    end

    test "annotation defined for attribute" do
      cX.ann(:x,:doc) == "still okay"
    end

  end

  context "both method and attribute annotations work" do

    cX = Class.new do
      include Anise::Method
      include Anise::Attribute

      method_annotator :doc

      attr :x, :doc => "still okay"

      doc "sure does"
      def y; end
    end

    test "annotation defined for attribute" do
      cX.ann(:x,:doc) == "still okay"
    end

    test "doc is defined for method" do
      cX.ann(:y,:doc) == "sure does"
    end

  end

end
