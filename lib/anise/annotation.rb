module Anise

  # = Runtime Annotations
  #
  # The Annotation module is the heart of the Anise system.
  # It provides the framework for annotating class or module related
  # objects, typically symbols representing methods, with arbitrary
  # metadata. These annotations do not do anything in themselves.
  # They are simply data. But you can put them to use. For instance
  # an attribute validator might check for an annotation called
  # :valid and test against it.
  #
  # == Synopsis
  #
  #   class X
  #     include Anise::Annotation
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
  #     ann :@a, :valid => lambda{ |x| x.is_a?(Integer) }
  #
  #     def validate
  #       instance_variables.each do |iv|
  #         if validator = self.class.ann(iv)[:valid]
  #           value = instance_variable_get(iv)
  #           unless validator.call(vale)
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
  #     ann self, :valid => lambda{ |x| x.is_a?(Integer) }
  #   end
  #
  # Altough annotations are arbitrary they are tied to the class or
  # module they are defined within.
  #
  #--
  # TODO: By using a global variable rather the definining a class
  #       instance variable for each class/module, it is possible to
  #       quicky scan all annotations for the entire system. To do
  #       the same without this would require scanning through
  #       the ObjectSpace. Should we do this?
  #         $annotations = Hash.new { |h,k| h[k] = {} }
  #
  # TODO: The ann(x).name notation is kind of nice. Would like to add that
  #       back-in if reasonable. This would require @annotations to be an
  #       OpenHash or OpenObject rather than just a Hash.
  #++
  module Annotation

    def self.append_features(base)
      base.extend self
    end

    # Stores this classes or modules annotations.
    #
    def annotations
      #$annotations[self]
      @annotations ||= {}
    end

    # Lookup an annotation. Unlike +annotations[ref]+
    # this provides a complete annotation <i>heritage</i>,
    # pulling annotations of the same reference name 
    # from ancestor classes and modules.
    #
    def annotation(ref)
      ref = ref.to_sym
      ann = {}
      ancestors.reverse_each do |anc|
        next unless anc.is_a?(Annotation)
        #anc.annotations[ref] ||= {}
        if anc.annotations[ref]
          ann.update(anc.annotations[ref]) #.merge(ann)
        end
      end
      return ann
      #ancs = ancestors.select{ |a| a.is_a?(Annotations) }
      #ancs.inject({}) do |memo, ancestor|
      #  ancestor.annotations[ref] ||= {}
      #  ancestor.annotations[ref].merge(memo)
      #end
    end

    # Set or read annotations.
    #
    def ann( ref, keys_or_class=nil, keys=nil )
      return annotation(ref) unless keys_or_class or keys

      if Class === keys_or_class
        keys ||= {}
        keys[:class] = keys_or_class
      else
        keys = keys_or_class
      end

      if Hash === keys
        ref  = ref.to_sym
        keys = keys.inject({}){ |h,(k,v)| h[k.to_sym] = v; h} #rekey
        annotations[ref] ||= {}
        annotations[ref].update(keys)
      else
        key = keys.to_sym
        annotation(ref)[key]
      end
    end

    # To change an annotation's value in place for a given class or module
    # it first must be duplicated, otherwise the change may effect annotations
    # in the class or module's ancestors.
    #
    def ann!( ref, keys_or_class=nil, keys=nil )
      #return annotation(ref) unless keys_or_class or keys
      return annotations[ref] unless keys_or_class or keys

      if Class === keys_or_class
        keys ||= {}
        keys[:class] = keys_or_class
      else
        keys = keys_or_class
      end

      if Hash === keys
        ref  = ref.to_sym
        keys = keys.inject({}){ |h,(k,v)| h[k.to_sym] = v; h} #rekey
        annotations[ref] ||= {}
        annotations[ref].update(keys)
      else
        key = keys.to_sym
        annotations[ref][key] = annotation(ref)[key].dup
      end
    end

  end

end

# 2006-11-07 trans  Created this ultra-concise version of annotations.
# Copyright (c) 2005, 2008 TigerOps

