module Anise

  module Annotative

    # I bet you never imagined Ruby could suport `@style` annotations.
    # Well, I am here to tell you otherwise.
    #
    # The {VariableAnnotator} module allows class instance variable to be
    # used method annotations which attach to the next defined method.
    #
    #   class X
    #     extend Anise::Annotative::Variables
    #
    #     variable_annotator :@doc
    #     variable_annotator :@returns
    #
    #     @doc = "See what I mean?"
    #     @returns = NilClass
    #
    #     def see
    #       puts "Yes, I see!"
    #     end
    #   end
    #
    #   X.ann(:see, :@doc) #=> "See what I mean?"
    #
    # This library uses the #method_added callback, so be sure to respect
    # good practices of calling +super+ if you need to override this method.
    #
    # **IMPORTANT!!!** This library is an interesting expirement, but it remains
    # to be determined if it makes sense for general use.
    #
    module Variables

      include Annotations
   
      #
      # Open method annotations.
      #
      # @example
      #   variable_annotator :@doc
      #
      # @param ns [Symbol]
      #   Annotator to use. Default is `:ann`.
      #
      def variable_annotator(iv, &block)
        # TODO: should none iv raise an error instead?
        iv = "@#{iv}".to_sym if iv.to_s !~ /^@/

        # TODO: use an annotation to record the annotators
        #ann(:variable_annotator, iv=>block)

        @_variable_annotations ||= {}
        @_variable_annotations[iv] = block
      end

      #
      def annotator(iv, &block)
        if not iv.to_s.start_with?('@')
          if defined?(super)
            super(iv, &block)
          else
            raise ArgumentError, "not a valid instance variable -- #{iv}"
          end
        else
          variable_annotator(iv, ns, &block)
        end
      end

      #
      # When a method is added, run all pending annotations.
      #
      def method_added(sym)
        @_variable_annotations ||= {}
        @_variable_annotations.each do |iv, block|
          if iv.to_s.index('/')
            iv, ns = iv.to_s.split('/')
          else
            ns = :ann
          end
          value = instance_variable_get(iv)
          if block
            block.call(sym, value)
          else
            ann(sym/ns, iv=>value)
          end
          # TODO: can we undefine the instance variable?
          instance_variable_set(iv, nil)
        end
        super(sym) if defined?(super)
      end

    end

  end

end

# Copyright (c) 2006 Rubyworks. All rights reserved. (BSD-2-Clause License)
