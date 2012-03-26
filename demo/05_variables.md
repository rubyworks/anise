# Variable Annotations

AnnotatedVariables is an experimental class and therefore must be
required specifically.

    require 'anise/variables'

Create a class that uses the `AnnotatedVariables` mixin.

    class X
      extend Anise::AnnotatedVariables

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
      extend Anise::AnnotatedVariables

      def self.list
        @list ||= []
      end

      variable_annotator :ann do |method, value|
        list << [method, value]
      end

      @doc = "See here!"

      def see
        puts "Yes, I see!"
      end
    end

See that it is set.
  
    Y.list #=> [[:see, "See here!"]]

