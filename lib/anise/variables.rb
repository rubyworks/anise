module Anise

  require 'anise'

  # TODO: Allow annotations to be inherited via module mixins.

  # TODO: Ensure thread-safety of `@_variable_annotations`.

  # I bet you never imagined Ruby could suport `@style` annotations.
  # Well, I am here to tell you otherwise.
  #
  # The {VariableAnnotations} module allows for the creation of <i>attribute variable annotations</i>
  # which attach to the next method defined.
  #
  #   require 'anise/variable'
  #
  #   class X
  #     extend Anise::VariableAnnotations
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
  # This library uses the #method_added callback, so be sure to respect
  # good practices of calling +super+ if you need to override this method.
  #
  # **IMPORTANT!!!** This library is an interesting expirement, but not really 
  # meant for actual production use.
  #
  module AnnotatedVariables
    include Annotations
 
    # When included into a class or module, Annotator is also included
    # and VariableAnnotation::Aid extends the class/module.
    #
    # @param base [Class, Module]
    #   The class or module to get features.
    #
    def self.included(base)
      variable_annotator :ann  # setup default annotator
    end

    #
    # Open method annotations.
    #
    # @param ns [Symbol]
    #   Annotator to use. Default is `:ann`.
    #
    def variable_annotator(ns=:ann, &block)
      @_variable_annotations = {
        :variables => instance_variables,
        :namespace => ns || :ann,
        :procedure => block
      }
    end

    #
    # When a method is added, run all pending annotations.
    #
    def method_added(sym)
      @_variable_annotations ||= {}
      fixed_variables = @_variable_annotations[:variables] || []
      annotations = (instance_variables - fixed_variables)
      annotations = annotations.reject { |a| a.to_s[0,2] == '@_' }
      annotations.each do |name|
        value = instance_variable_get(name)
        if block = @_variable_annotations[:procedure]
          block.call(sym, value)
        else
          if ns = @_variable_annotations[:namespace]
            ann(sym/ns, name=>value)
          else
            ann(sym, name=>value)
          end
        end
      end
      # TODO: can we undefine the instance variables?
      @_variable_annotations[:variables] = instance_variables

      super if defined?(super)
    end

  end

end

# Copyright (c) 2006 Rubyworks. All rights reserved. (BSD-2-Clause License)
