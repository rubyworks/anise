module Anise

  module Annotative

    # TODO: Ensure thread-safety of <code>@_pending_annotations</code> variable.

    # The Annotator::Method module allows for the creation of annotations
    # which attach to the next method defined.
    #
    # This idiom of annotation-before-definition was popularized by Rake's
    # `desc`/`task` pair. This module can be used to add similar capabilites
    # to any class or module.
    #
    #     class X
    #       extend Anise::Annotative::Methods
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
    #       method_annotation do |meth|
    #         ann meth, :doc => string
    #       end
    #     end
    #
    # Note that the library uses the #method_added callback, so be sure to
    # respect good practices of calling +super+ if you need to override
    # this method.
    #
    module Methods

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
      def method_annotator(name, &block)
        (class << self; self; end).module_eval do
          define_method(name) do |*args|
            anns = { name => (args.size > 1 ? args : args.first) }
            Methods.pending_annotations[self] << [anns, block]
          end
        end
      end

      #
      #
      #
      def annotator(name, &block)
        if name.to_s.start_with?('@')
          if defined?(super)
            super(name, &block)
          else
            raise ArgumentError, "not a valid method name -- #{name}"
          end
        else
          method_annotator(name, &block)
        end
      end

      #
      # Setup a pending method annotation.
      #
      # @param [Hash] annotations
      #   The annotation settings.
      #
      def method_annotation(*args, &block)
        anns = (Hash === args.last ? args.pop : {})
        Methods.pending_annotations[self] << [anns, block]
      end

      #
      # When a method is added, run all pending annotations.
      #
      # @param [Symbol] sym
      #   The name of the method added.
      #
      def method_added(sym)
        annotations = Methods.pending_annotations[self]
        annotations.each do |anns, block|
          if block
            block.call(sym)
          else
            anns.each do |name, value|
              if name.to_s.index('/')
                name, ns = name.to_s.split('/')
              else
                ns = :ann
              end
              ann(sym/ns, name=>value)
            end
          end
        end
        Methods.pending_annotations[self] = []
        super if defined?(super)
      end

    end

  end

end

# Copyright (c) 2006 Rubyworks. All rights reserved. (BSD-2-Clause License)
