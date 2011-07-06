= Method Annotation

Load the `anise/method.rb` library.

  require 'anise/method'

Create a class that includes it.

  class X
    include Anise::Method

    method_annotator :doc

    doc "See what I mean?"
  
    def see
      puts "Yes, I see!"
    end
  end

See that it is set.
  
  X.ann(:see, :doc)  #=> "See what I mean?"

Method Annotators can override the standard annotation procedure
with a custom procedure.

  class Y
    include Anise::Method

    def self.list
      @list ||= []
    end

    method_annotator :doc do |method, argument|
      list << [method, argument]
    end

    doc "See here!"
  
    def see
      puts "Yes, I see!"
    end
  end

See that it is set.
  
  Y.list #=> [[:see, "See here!"]]

