module Anise
  require 'anise/annotation'

  # Method Annotations
  #
  # The MethodAnnotation module allows for the creation of <i>method annotations</i>
  # which attach to the next method defined.
  #
  # This idiom of annotation-before-definition was popularized by Rake's
  # `desc`/`task` pair. The MethodAnnotation module can be used to add
  # similar capabilites to any program.
  #
  #   require 'anise/method'
  #
  #   class X
  #     include Anise::Method
  #
  #     method_annotator :doc
  #
  #     doc "See what I mean?"
  #
  #     def see
  #       puts "Yes, I see!"
  #     end
  #   end
  #
  #   X.ann(:see, :doc) #=> "See what I mean?"
  #
  # Note that the library uses the #method_added callback, so be sure to
  # respect good practices of calling +super+ if you need to override
  # this method.
  #
  #--
  # TODO: Allow method annotations to be inherited via module mixins.
  #
  # TODO: Ensure thread-safety of <code>@_pending_annotations</code> variable.
  #++
  module Method
    # When included into a class or module, Annotation is also included
    # and Method::Aid extends the class/module.
    #
    # @param base [Class, Module]
    #   The class or module to get features.
    #
    def self.included(base)
      base.send(:include, Annotation) #unless base.is_a?(Annotation)
      base.extend Aid
    end

    module Aid
      # Define a method annotation.
      #
      # @param name [Symbol]
      #   Name of annotation.
      #
      # @param ns [Symbol]
      #   Annotator to use. Default is `:ann`.
      #
      def method_annotator(name, ns=:ann, &block)
        annotator ns  # TODO: unless defined annotator ?
        (class << self; self; end).module_eval do
          define_method(name) do |*args|
            @_pending_annotations ||= []
            @_pending_annotations << [name, ns, args, block]
          end
        end
      end

      # When a method is added, run all pending annotations.
      def method_added(sym)
        @_pending_annotations ||= []
        @_pending_annotations.each do |name, ns, args, block|
          if block
            block.call(sym, *args)
          else
            if args.size == 1
              send(ns, sym, name=>args.first)
            else
              send(ns, sym, name=>args)
            end
          end
        end
        @_pending_annotations = []
        super if defined?(super)
      end
    end
  end

end

# Copyright (c) 2006,2011 Thomas Sawyer. All rights reserved. (BSD-2-Clause License)
