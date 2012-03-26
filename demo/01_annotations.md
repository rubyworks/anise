# Annotations

## Creating and Reading Annotations

Load the Anise library.

    require 'anise'

Given an example class X we can apply annotations to it using the #ann method. 

    class X
      extend Anise::Annotations

      ann :x1, :a=>1
      ann :x1, :b=>2
    end

We can then use #ann to lookup the set annotations.

    X.ann(:x1,:a).should == 1

The #ann method is a public interface, so we can define annotation externally as well.

    X.ann :x1, :a => 2
    X.ann(:x1, :a).should == 2

## Annotation Added Callback

Given a sample class Y, we can use a standard callback method #annotation_added().

    class Y
      extend Anise::Annotations

      class << self
        attr :last_callback

        def annotation_added(ref, ns)
          @last_callback = [ns, ref, ann(ref/ns)]
        end
      end
    end

Now if we add an annotation, we will see the callback catches it.

    Y.ann :x1, :a=>1
    Y.last_callback.should == [:ann, :x1, {:a => 1}]

We will do it again to be sure.

    Y.ann :x1, :b=>2
    Y.last_callback.should == [:ann, :x1, {:a => 1, :b => 2}]

## Using Callbacks for Attribute Defaults

    class ::Module
      def annotation_added(key, ns)
        return unless ns == :ann
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

    class Z
      extend Anise::Annotations

      attr :a
      ann :a, :default => 10
    end

    z = Z.new
    z.a.should == 10
    z.a.should == 10

