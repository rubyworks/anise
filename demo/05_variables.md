# Variable Annotations

Create a class that uses the `Annotative::Variables` mixin.

    class X
      extend Anise::Annotative::Variables

      variable_annotator :@doc

      @doc = "See what I mean?"

      def see
        puts "Yes, I see!"
      end
    end

See that it is set.
  
    X.ann(:see, :@doc).should == "See what I mean?"

Variable annotations can override the standard annotation procedure with a
custom procedure.

    class Y
      extend Anise::Annotative::Variables

      def self.list
        @list ||= []
      end

      variable_annotator :@doc do |method, value|
        list << [method, value]
      end

      @doc = "See here!"

      def see
        puts "Yes, I see!"
      end
    end

See that it is set.
  
    Y.list #=> [[:see, "See here!"]]

