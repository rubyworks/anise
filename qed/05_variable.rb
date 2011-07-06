= Variable Annotations

Load the `anise/variable.rb` library.

  require 'anise/variable'

Create a class that uses it.

  class X
    include Anise::Variable

    @doc = "See what I mean?"

    def see
      puts "Yes, I see!"
    end
  end

See that it is set.
  
  X.ann(:see, :@doc).assert == "See what I mean?"

Annotations can override the standard annotation procedure with a
custom procedure.

  class Y
    include Anise::Variable

    def self.list
      @list ||= []
    end

    variable_annotator :ann do |method, argument|
      list << [method, argument]
    end

    @doc = "See here!"

    def see
      puts "Yes, I see!"
    end
  end

See that it is set.
  
  Y.list #=> [[:see, "See here!"]]

