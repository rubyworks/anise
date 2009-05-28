= Callbacks

Load the annotations, which supports callbacks out of the box.

  require 'anise/annotation'

Given a sample class X, we can use a standard callback method #annotation_added().

  class X
    include Anise::Annotation

    class << self
      attr :last_callback

      def annotation_added(name)
        @last_callback = [name, ann(name)]
      end
    end
  end

Now if we add an annotation, we will see the callback catches it.

  X.ann :x1, :a=>1
  X.last_callback.should == [:x1, {:a => 1}]

We'll do it again to be sure.

  X.ann :x1, :b=>2
  X.last_callback.should == [:x1, {:a => 1, :b => 2}]

== Using Callbacks for Attribute Defaults

  class ::Module
    def annotation_added(key)
      base = self
      if value = ann(key, :default)
        define_method(key) do
          instance_variable_set("@#{key}", value) unless instance_variable_defined?("@#{key}")
          base.module_eval{ attr key }
          instance_variable_get("@#{key}")
        end 
      end
    end
  end

Try it out.

  class Y
    include Anise::Annotation

    attr :a
    ann :a, :default => 10
  end

  x = Y.new
  x.a.should == 10
  x.a.should == 10

QED.

