module Anise
  require 'anise/annotation'

  # Variable Annotations
  #
  # I bet you never imagined Ruby could suport `@style` annotations.
  # Well, I am here to tell you otherwise.
  #
  # The MethodAnnotation module allows for the creation of <i>method annotations</i>
  # which attach to the next method defined.
  #
  #   require 'anise/variable'
  #
  #   class X
  #     include Anise::Variable
  #
  #     @doc     = "See what I mean?"
  #     @returns = NilClass
  #
  #     def see
  #       puts "Yes, I see!"
  #     end
  #   end
  #
  #   X.ann(:see, :@doc) #=> "See what I mean?"
  #
  # Note that the library uses the #method_added callback, so be sure to
  # respect good practices of calling +super+ if you need to override
  # this method.
  #
  #--
  # TODO: Allow annotations to be inherited via module mixins.
  #
  # TODO: Ensure thread-safety of `@_annotation_*` variables.
  #++
  module Variable
    # When included into a class or module, Annotator is also included
    # and VariableAnnotation::Aid extends the class/module.
    #
    # @param base [Class, Module]
    #   The class or module to get features.
    #
    def self.included(base)
      base.send(:include, Annotation) #unless base.is_a?(Annotator)
      base.extend Aid
      base.variable_annotator :ann  # setup default annotator
    end

    module Aid
      # Open method annotations.
      #
      # @param ns [Symbol]
      #   Annotator to use. Default is `:ann`.
      #
      def variable_annotator(ns=:ann, &block)
        annotator ns  # setup annotator

        @_annotation_space = ns
        @_annotation_block = block
        @_annotation_state = instance_variables
      end

      # When a method is added, run all pending annotations.
      def method_added(sym)
        if @_annotation_space
          annotations = (instance_variables - @_annotation_state)
          annotations = annotations.reject { |a| a.to_s[0,2] == '@_' }
          annotations.each do |name|
            value = instance_variable_get(name)
            if @_annotation_block
              @_annotation_block.call(sym, value)
            else
              send(@_annotation_space, sym, name=>value)
            end
          end
          @_annotation_state = instance_variables
        end
        super if defined?(super)
      end
    end
  end

end

# Copyright (c) 2006,2011 Thomas Sawyer. All rights reserved. (BSD-2-Clause License)
