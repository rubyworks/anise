require 'anise/annotation'

Test.case Anise::Annotation do 

  concern "annotations can be defined" do

    cX = Class.new do
      include Anise::Annotation
      annotator :ann
      def x1 ; end
      ann :x1, :a=>1
      ann :x1, :b=>2
    end

    test "01" do
      cX.ann(:x1,:a) == cX.ann(:x1,:a)
    end

    test "02" do
      cX.ann(:x1,:a).object_id == cX.ann(:x1,:a).object_id
    end

    test "03" do
      cX.ann(:x1,:a) == 1
    end

    test "04" do
      cX.ann :x1, :a => 2
      cX.ann(:x1,:a) == 2
    end

  end

  concern "parent annotations pass to subclass" do

    cX = Class.new do
      include Anise::Annotation
      annotator :ann
      def x1 ; end
      ann :x1, :a=>1
      ann :x1, :b=>2
    end

    cY = Class.new(cX)

    test "01" do
      cY.ann(:x1,:a) == cY.ann(:x1,:a)
    end

    test "02" do
      cY.ann(:x1,:a).object_id == cY.ann(:x1,:a).object_id
    end

    test "03" do
      cY.ann(:x1,:a) == 1
    end

    test "04" do
      cY.ann(:x1,:b) == 2
    end

    test "05" do
      cY.ann :x1,:a => 2
      cY.ann(:x1,:a) == 2 &&
      cY.ann(:x1,:b) == 2
    end

  end

  concern "subclass can override parent annotation" do

    cX = Class.new do
      include Anise::Annotation

      annotator :ann

      ann :foo, Integer
    end

    cY = Class.new(cX) do
      ann :foo, String
    end

    test "01" do
      cX.ann(:foo, :class) == Integer
    end

    test "02" do
      cY.ann(:foo, :class) == String
    end

  end

  concern "subclass can override while parent also passes thru" do

    cX = Class.new do
      include Anise::Annotation
      annotator :ann
      ann :foo, :doc => "hello"
      ann :foo, :bar => []
    end

    cY = Class.new(cX) do
      ann :foo, :class=>String, :doc=>"bye"
    end

    test "01" do
      cX.ann(:foo,:doc) == "hello"
    end

    test "02" do
      cX.ann(:foo) == {:doc=>"hello", :bar=>[]}
    end

    test "03" do
      cX.ann(:foo,:bar) << "1"
      cX.ann(:foo,:bar) == ["1"]
    end

    test "04" do
      cY.ann(:foo,:doc) == "bye"
    end

    test "05" do
      #Y.ann(:foo,:bar) == nil
      cY.ann(:foo,:bar) == ["1"]
    end

    test "06" do
      cY.ann(:foo, :doc => "cap")
      cY.ann(:foo, :doc) == "cap"
    end

    test "07" do
      cY.ann!(:foo,:bar) << "2"

      cY.ann(:foo,:bar) == ["1", "2"] &&
      cY.ann(:foo,:bar) == ["1", "2"] &&
      cX.ann(:foo,:bar) == ["1"]
    end

  end

  concern "example of using annotations for validation" do

    cX = Class.new do
      include Anise::Annotation

      annotator :ann

      attr :a

      ann :@a, :valid => lambda{ |x| x.is_a?(Integer) }
      ann :a,  :class => Integer

      def initialize(a)
        @a = a
      end

      def validate
        instance_variables.each do |iv|
          if validator = self.class.ann(iv)[:valid]
            value = instance_variable_get(iv)
            unless validator.call(value)
              raise "Invalid value #{value} for #{iv}"
            end
          end
        end
      end
    end

    test "annotation class" do
      cX.ann(:a, :class) == Integer
    end

    test "annotation validate" do
      r = cX.new(1)
      r.validate
    end

  end

end
