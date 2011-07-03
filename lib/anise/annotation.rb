module Anise

  # The Annotate module is the core of the Anise system. It provides the
  # framework for annotating class or module related objects, typically
  # symbols representing methods, with arbitrary metadata. These annotations
  # do not do anything in themselves. They are simply data. But they can be
  # put to good use. For instance an attribute validator might check for an
  # annotation called :valid and test against it.
  #
  # == Synopsis
  #
  #   require 'anise/annotation'
  #
  #   class X
  #     include Anise::Annotation
  #
  #     annotator :ann
  #
  #     attr :a
  #
  #     ann :a, :desc => "A Number"
  #   end
  #
  #   X.ann(:a, :desc)  #=> "A Number"
  #
  # As stated, annotations need not only annotate methods, they are
  # arbitrary, so they can be used for any purpose. For example, we
  # may want to annotate instance variables.
  #
  #   class X
  #     include Anise::Annotation
  #
  #     annotator :ann
  #
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
  #     include Anise::Annotation
  #
  #     annotator :ann
  #
  #     ann self, :valid => lambda{ |x| x.is_a?(Enumerable) }
  #   end
  #
  # Although annotations are arbitrary they are tied to the class or
  # module they are defined against.
  #
  #--
  # TODO: The ann(x).name notation is kind of nice. Would like to add that
  #       back-in if reasonable. This would require @annotations to be an
  #       OpenHash or OpenObject rather than just a Hash though.
  #++
  module Annotation

    #
    #
    def self.included(base)
      base.extend Aid
    end

    # Anise::Annotation Domain Language
    #
    module Aid

      # Define a new annotator.
      #
      def annotator(name)
        include Anise::Annotation

        module_eval <<-END, __FILE__, __LINE__
          def self.#{name}(ref, *keys)
            annotation_lookup(:#{name}, ref, *keys)
          end
          def self.#{name}!(ref, *keys)
            annotation_lookup!(:#{name}, ref, *keys)
          end
        END
      end

      # Lookup an annotation. Unlike +annotations[ref]+
      # this provides a complete annotation <i>heritage</i>,
      # pulling annotations of the same reference name
      # from ancestor classes and modules.
      #
      # @param ref [Object] annotation reference key
      #
      # @param ns [Symbol] annotation namespace
      #
      def annotation(ref=nil, ns=nil)
        return(@annotations ||= Hash.new{|h,k| h[k]={}}) if ref.nil?

        ns  = ns.to_sym
        ref = ref.to_sym
        ann = {}
        ancestors.reverse_each do |anc|
          next unless anc < Annotation
          if h = anc.annotations[ns][ref]
            ann.merge!(h)
          end
        end
        return ann
      end

      # Plural alias for #annotation.
      #
      alias_method :annotations, :annotation

      # Set or read annotations.
      #
      # @pararm ns [Symbol] namespace
      #
      # @param ref [Object] annotation reference key
      #
      def annotation_lookup(ns, ref, keys_or_class=nil, keys=nil)
        return annotation(ref, ns) unless keys_or_class or keys

        if Class === keys_or_class
          keys ||= {}
          keys[:class] = keys_or_class
        else
          keys = keys_or_class
        end

        if Hash === keys
          ref  = ref.to_sym
          keys = keys.inject({}){ |h,(k,v)| h[k.to_sym] = v; h} #rekey
          annotations[ns][ref] ||= {}
          annotations[ns][ref].update(keys)
          # callback
          annotation_added(ns, ref) #if method_defined?(:annotation_added)
        else
          key = keys.to_sym
          annotation(ref, ns)[key]
        end
      end

      # To change an annotation's value in place for a given class or module
      # it first must be duplicated, otherwise the change may effect annotations
      # in the class or module's ancestors.
      #
      # @pararm ns [Symbol] namespace
      #
      # @param ref [Object] annotation reference key
      #
      def annotation_lookup!(ns, ref, keys_or_class=nil, keys=nil)
        #return annotation(ref, ns) unless keys_or_class or keys
        unless keys_or_class or keys
          return annotations[ns][ref] ||= {}
        end

        if Class === keys_or_class
          keys ||= {}
          keys[:class] = keys_or_class
        else
          keys = keys_or_class
        end

        if Hash === keys
          ref  = ref.to_sym
          keys = keys.inject({}){ |h,(k,v)| h[k.to_sym] = v; h} #rekey
          annotations[ns][ref] ||= {}
          annotations[ns][ref].update(keys)
          # callback
          annotation_added(ns, ref) #if method_defined?(:annotation_added)
        else
          key = keys.to_sym
          annotations[ns][ref] ||= {}
          begin
            annotations[ns][ref][key] = annotation(ref, ns)[key].dup
          rescue TypeError
            annotations[ns][ref][key] = annotation(ref, ns)[key]
          end
        end
      end

      # Callback method. This method is called for each new annotation.
      #
      def annotation_added(ns, name)
        super(ns, name) if defined?(super)
      end

    end

  end

end

=begin
class Module
  # Define a new annotator.
  #
  def annotator(name)
    include Anise::Annotation

    module_eval <<-END, __FILE__, __LINE__
      def self.#{name}(ref, *keys)
        annotation_lookup(:#{name}, ref, *keys)
      end
      def self.#{name}!(ref, *keys)
        annotation_lookup!(:#{name}, ref, *keys)
      end
    END
  end
end
=end

def annotator(name)
  include Anise::Annotation

  Object.class_eval <<-END, __FILE__, __LINE__
    def self.#{name}(ref, *keys)
      annotation_lookup(:#{name}, ref, *keys)
    end
    def self.#{name}!(ref, *keys)
      annotation_lookup!(:#{name}, ref, *keys)
    end
  END
end


# Copyright (c) 2006-11-07 Thomas Sawyer
