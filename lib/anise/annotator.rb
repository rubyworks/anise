module Anise
  require 'anise/annotation'

  # = Annotator
  #
  # The Annotator module allows for the creation of <i>method annotations</i>
  # which attach to the next method defined.
  #
  # This idiom of annotator-before-definition was popularized by
  # Rake's desc/task pair. The Annotator module makes it very easy
  # to add similar capabilites to any program.
  #
  #   require 'anise/annotator'
  #
  #   class X
  #     include Anise::Annotator
  #
  #     annotator :doc
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
  # this method while using Annotator.
  #
  #--
  # TODO: Allow annotators to be inherited via module mixins.
  #
  # TODO: Ensure thread-safety of <code>@_pending_annotations</code> variable.
  #++
  module Annotator

    #
    def self.append_features(base)
      Annotation.append_features(base) #unless base.is_a?(Annotation)
      base.extend ClassMethods
      super(base)
    end

    module ClassMethods

      # Define an annotator.
      def annotator(name, &block)
        (class << self; self; end).module_eval do
          define_method(name) do |*args|
            @_pending_annotations ||= []
            @_pending_annotations << [name, args, block]
          end
        end
      end

      # When a method is added, run all pending annotations.
      def method_added(sym)
        @_pending_annotations ||= []
        @_pending_annotations.each do |name, args, block|
          if block
            block.call(sym, *args)
          else
            if args.size == 1
              ann(sym, name=>args.first)
            else
              ann(sym, name=>args)
            end
          end
        end
        @_pending_annotations = []
        super if defined?(super)
      end

    end

  end

end

# Copyright (c) 2005,2011 Thomas Sawyer
