module Anise

  # TODO: Allow method annotations to be inherited via module mixins.

  # TODO: Ensure thread-safety of <code>@_pending_annotations</code> variable.

  # The AnnotatedMethods module allows for the creation of <i>method annotations</i>
  # which attach to the next method defined.
  #
  # This idiom of annotation-before-definition was popularized by Rake's
  # `desc`/`task` pair. The MethodAnnotation module can be used to add
  # similar capabilites to any program.
  #
  #     class X
  #       extend Anise::AnnotatedMethods
  #
  #       def self.doc(string)
  #         method_annotation(:doc => string)
  #       end
  #
  #       doc "See what I mean?"
  #
  #       def see
  #         puts "Yes, I see!"
  #       end
  #     end
  #
  #     X.ann(:see, :doc) #=> "See what I mean?"
  #
  # One can get a bit more control over the creation of annotations
  # by using a block. In this case it is up the code to actually
  # create the annotation.
  #
  #     def self.doc(string)
  #       pending_annotation(:ann) do |meth|
  #         ann meth, :doc => string
  #       end
  #     end
  #
  # Note that the library uses the #method_added callback, so be sure to
  # respect good practices of calling +super+ if you need to override
  # this method.
  #
  module AnnotatedMethods
    include Annotations

    #
    # This a temporary store used to create method annotations.
    #
    def self.pending_annotations
      @_pending_annotations ||= Hash.new{ |h,k| h[k] = [] }
    end

    #
    # Define a method annotation.
    #
    # @example
    #   method_annotator :doc
    #
    # @param name [Symbol]
    #   Name of annotation.
    #
    # @param ns [Symbol]
    #   Annotator to use. Default is `:ann`.
    #
    # @deprecated Define class method and use #pending_annotation instead.
    #
    def method_annotator(name, ns=:ann, &block)
      #include Annotator[ns] unless method_defind?(ns) # TODO: correct?

      (class << self; self; end).module_eval do
        define_method(name) do |*args|
          anns = { name => (args.size > 1 ? args : args.first) }
          AnnotatedMethods.pending_annotations[self] << [ns, anns, block]
        end
      end
    end

    #
    # Setup a pending method annotation.
    #
    # @param [Symbol] annotator (optional)
    #   The name of the annotator, if different than standard `:ann`.
    #
    # @param [Hash] annotations
    #   The annotation settings.
    #
    def method_annotation(*args, &block)
      anns = (Hash === args.last ? args.pop : {})
      ns   = args.shift || :ann

      #annotator(ns) unless method_defind?(ns) # TODO: correct?

      AnnotatedMethods.pending_annotations[self] << [ns, anns, block]
    end

    #
    # When a method is added, run all pending annotations.
    #
    # @param [Symbol] sym
    #   The name of the method added.
    #
    def method_added(sym)
      annotations = AnnotatedMethods.pending_annotations[self]

      annotations.each do |ns, anns, block|
        if block
          block.call(sym)
        end
        ann(sym/ns, anns) if anns && !anns.empty?
      end

      AnnotatedMethods.pending_annotations[self] = []

      super if defined?(super)
    end

  end

end

# Copyright (c) 2006 Rubyworks. All rights reserved. (BSD-2-Clause License)
