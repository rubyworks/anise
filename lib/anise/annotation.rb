module Anise

  # The Annotation module is the core of the Anise system. It provides the
  # framework for annotating class and module related objects, typically
  # symbols representing methods, with arbitrary metadata. These annotations
  # do not do anything in themselves. They are simply data. But they can be
  # put to good use. For instance an attribute validator might check for an
  # annotation called :valid and test against it.
  #
  # The name of an annotation store can be any symbol. The `:ann` store is 
  # the <i>common annotaation store</i>, and is the defualt value of many
  # annotating methods.
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

    require 'anise/annotator'  # FIXME

    # When included into a class or module, {Annotator::Aid} extends
    # the class/module.
    #
    # @param base [Class, Module]
    #   The class or module to get features.
    #
    def self.included(base)
      base.extend Aid
    end

    # Anise::Annotation Domain Language
    #
    module Aid

      # Define a new annotator.
      #
      # @param ns [Symbol] Annotation namespace.
      #
      # @since 0.7.0
      def annotator(ns=:ann)
        include Anise::Annotation

        module_eval <<-END, __FILE__, __LINE__
          def self.#{ns}(ref, *keys)
            if keys.empty?
              annotations.lookup(ref, :#{ns})
            else
              annotations.annotate(:#{ns}, ref, *keys)
            end
          end
          def self.#{ns}!(ref, *keys)
            if keys.empty?
              annotations[ref, :#{ns}]
            else
              annotations.annotate!(:#{ns}, ref, *keys)
            end
          end
        END
      end

      # Access to class or module's annotations.
      def annotations
        @annotations ||= Annotations.new(self)
      end

=begin
      # Lookup an annotation. Unlike +annotations[ns][ref]+
      # this provides a complete annotation <i>heritage</i>,
      # pulling annotations of the same reference name
      # from ancestor classes and modules.
      #
      # Unlike the other annotation methods, this method takes
      # the `ref` argument before the `ns` argument. This is
      # it allow `ns` to default to the common annotator `ann`.
      #
      # @param ref [Object] Annotation reference key.
      #
      # @param ns [Symbol] Annotation namespace.
      #
      def annotation(ref=nil, ns=:ann)
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

      alias_method :annotations, :annotation

      # Set or read annotations.
      #
      # IMPORTANT! Do not use this for in-place modifications.
      # Use #annotate! instead.
      # 
      # @pararm ns [Symbol] Annotation namespace.
      #
      # @param ref [Object] Annotation reference key.
      #
      # @since 0.7.0
      def annotate(ns, ref, keys_or_class=nil, keys=nil)
        return annotations(ref, ns) unless keys_or_class or keys

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
          annotations(ref, ns)[key]
        end
      end

      # To change an annotation's value in place for a given class or module
      # it first must be duplicated, otherwise the change may effect annotations
      # in the class or module's ancestors.
      #
      # @pararm ns [Symbol] Annotation namespace.
      #
      # @param ref [Object] Annotation reference key.
      #
      # @since 0.7.0
      def annotate!(ns, ref, keys_or_class=nil, keys=nil)
        #return annotations(ref, ns) unless keys_or_class or keys
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
            annotations[ns][ref][key] = annotations(ref, ns)[key].dup
          rescue TypeError
            annotations[ns][ref][key] = annotations(ref, ns)[key]
          end
        end
      end
=end

      # Callback method. This method is called for each new annotation.
      #
      def annotation_added(ns, ref)
        super(ns, ref) if defined?(super)
      end

    end

  end

end

# Copyright (c) 2006,2011 Thomas Sawyer. All rights reserved. (BSD-2-Clause License)
