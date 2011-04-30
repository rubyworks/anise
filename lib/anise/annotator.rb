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
  # NOTE: This module might be deprecated in a future version.
  # The same effect can be achieved via other means such as the generally
  # more useful `NoBacksies` gem.
  #
  # Here is an example of defining annotators using the NoBacksies mixin.
  #
  #   class Y
  #     include NoBacksies::Callbacks
  #     include Anise::Annotation
  #
  #     def self.doc(string)
  #       callback :method_added, :once=>true do |method|
  #         ann(method, :doc=>string)
  #       end
  #     end
  #
  #     doc "here"
  #
  #     def foo
  #       # ...
  #     end
  #   end
  #
  #   Y.ann(:foo, :doc) #=> "here"
  #
  # While it is  not as concise as the orginal annotator code, it is far more
  # succicent in that it makes it very clear as to what is occuring, and it is
  # much more flexible in that it allows the callback procedure to work in
  # any way possible.
  #
  #--
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
          define_method(name) do |arg|
            @_pending_annotations ||= []
            @_pending_annotations << [name, arg, block]
          end
        end
      end

      #

      def method_added(sym)
        @_pending_annotations ||= []
        @_pending_annotations.each do |name, arg, block|
          if block
            block.call(sym, arg)
          else
            ann(sym, name=>arg)
          end
        end
        @_pending_annotations = []
        super if defined?(super)
      end

    end

  end

end

# Copyright (c) 2005,2011 Thomas Sawyer
