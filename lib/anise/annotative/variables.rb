module Anise

  module Annotative

    # I bet you never imagined Ruby could suport `@style` annotations.
    # Well, I am here to tell you otherwise.
    #
    # The {VariableAnnotator} module allows class instance variable to be
    # used method annotations which attach to the next defined method.
    #
    #   class X
    #     extend Anise::VariableAnnotator
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
    # to be determined if it makes sense for production use.
    #
    module Variables

      include Annotations
   
      #
      # Open method annotations.
      #
      # @param ns [Symbol]
      #   Annotator to use. Default is `:ann`.
      #
      def variable_annotator(iv, ns=:ann, &block)
        iv = "@#{iv}".to_sym if iv.to_s !~ /^@/

        # TODO: use an annotation to record the annotators
        #ann(:variable_annotator/ns, iv=>block)

        @_variable_annotations ||= {}
        @_variable_annotations[[iv, ns]] = block
      end

      #
      # When a method is added, run all pending annotations.
      #
      def method_added(sym)
        @_variable_annotations ||= {}
        @_variable_annotations.each do |(iv,ns),block|
          value = instance_variable_get(iv)
          if block
            block.call(sym, value)
          else
            ann(sym/ns, iv=>value)
          end
          instance_variable_set(iv, nil) # TODO: can we undefine the instance variables?
        end
        super if defined?(super)
      end

    end

  end

end

# Copyright (c) 2006 Rubyworks. All rights reserved. (BSD-2-Clause License)
