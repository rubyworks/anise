module Anise

  # TODO: The ann(x).name notation is kind of nice. Would like to add that
  #       back-in if reasonable.

  # The Annotation provides a framework for annotating class and module related
  # objects, typically symbols representing methods, with arbitrary metadata.
  # These annotations do not do anything in themselves. They are simply data.
  # But they can be put to good use. For instance an attribute validator might
  # check for an annotation called :valid and test against it.
  #
  # The standard annotator is `:ann` and is the defualt value of  annotating
  # methods.
  #
  #   require 'anise/annotation'
  #
  #   class X
  #     include Anise::Annotation
  #
  #     ann :a, :desc => "A Number"
  #
  #     attr :a
  #   end
  #
  #   X.ann(:a, :desc)  #=> "A Number"
  #
  # As stated, annotations need not only annotate methods, they are
  # arbitrary, so they can be used for any purpose. For example, we
  # may want to annotate instance variables.
  #
  #   class X
  #     ann :@a, :valid => lambda{ |x| x.is_a?(Integer) }
  #
  #     def validate
  #       instance_variables.each do |iv|
  #         if validator = self.class.ann(iv)[:valid]
  #           value = instance_variable_get(iv)
  #           unless validator.call(value)
  #             raise "Invalid value #{value} for #{iv}"
  #           end
  #         end
  #       end
  #     end
  #   end
  #
  # Or, we could even annotate the class itself.
  #
  #   class X
  #     ann self, :valid => lambda{ |x| x.is_a?(Enumerable) }
  #   end
  #
  # Although annotations are arbitrary they are tied to the class or
  # module they are defined against.
  #
  # Creating custom annotators used to entail using a special `#annotator` method,
  # but this limited the way custom annotators could operate. The new way
  # is to define a custom class method that calls the usual `#ann` method,
  # but add in a namespace.
  #
  #   class X
  #     def self.cool(ref, *keys)
  #       ann "#{ref}/cool", *keys
  #     end
  #   end
  #
  #   X.cool(:a, :desc) #=> "Awesome!"
  #
  # The result is exactly the same as before, but now the custom annotator
  # has complete control over the process.
  #
  module Annotation

    require 'anise/annotations'  # FIXME

    #
    #
    #
    def self.included(base)
      base.extend Extensions
    end

  end

  # Anise::Annotation class-level methods.
  #
  module Extensions

    #
    # Access to a class or module's annotations.
    #
    def annotations
      @annotations ||= Annotations.new(self)
    end

    #
    # Callback method. This method is called for each new annotation.
    #
    def annotation_added(ref, ns=:ann)
      super(ref, ns) if defined?(super)
    end

    #
    # ann :ref, :key=>value
    # ann :ns, ref, :key=>value
    #
    # ann :ref, :key
    # ann :ns, :ref, :key
    #
    def ann(ref, *keys)
      if ref.to_s.index('/')
        ref, ns = ref.to_s.split('/')
      else
        ns = :ann
      end
      ref, ns = ref.to_sym, ns.to_sym

      if keys.empty?
        annotations.lookup(ref, ns)
      else
        annotations.annotate(ns, ref, *keys)
      end
    end

    #
    #
    #
    def ann!(ref, *keys)
      if ref.to_s.index('/')
        ref, ns = ref.to_s.split('/')
      else
        ns = :ann
      end
      ref, ns = ref.to_sym, ns.to_sym

      if keys.empty?
        annotations[ref, ns]
      else
        annotations.annotate!(ns, ref, *keys)
      end
    end

  end

end

# Copyright (c) 2006 Rubyworks. All rights reserved. (BSD-2-Clause License)
