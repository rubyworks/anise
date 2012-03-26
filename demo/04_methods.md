# Method Annotations

Create a class that uses the `AnnotatedMethods` mixin.

    class X
      extend Anise::AnnotatedMethods

      def self.doc(string)
        method_annotation(:doc=>string.to_s)
      end

      doc "See what I mean?"

      def see
        puts "Yes, I see!"
      end
    end

See that it is set.
  
    X.ann(:see, :doc)  #=> "See what I mean?"

Method Annotators can override the standard annotation procedure
with a custom procedure. In such case no annotations will actually
be created unless the `#ann` is called in the procedure.

    class Y
      extend Anise::AnnotatedMethods

      def self.list
        @list ||= []
      end

      def self.doc(string)
        method_annotation do |method|
          list << [method, string]
        end
      end

      doc "See here!"
    
      def see
        puts "Yes, I see!"
      end
    end

See that it is set.
  
    Y.list #=> [[:see, "See here!"]]

