module Anise
  require 'anise/annotation.rb'

  # = Annotator
  #
  # Annotator allows for the creation of dynamic <i>method
  # annotations</i> which attach to the next method defined.
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
  # This idiom of annotator before definition was popularized by
  # Rake's desc/task pair. Annotator makes it very easy to add
  # similar capabilites to any program.
  #
  # The library uses the #method_added callback, so be sure to
  # respect good practices of calling +super+ if you need to override
  # this method while using Annotator.
  #
  # TODO: Ensure thread safety of the internal <code>@pending_annotations</code> variable.
  #
  module Annotator

    def self.append_features(base)
      #if base == Object
      #  Module.send(:include, self)  # FIXME: Module ?
      #else
        base.extend Annotation #unless base.is_a?(Annotation)
        base.extend self
      #end
    end

    def annotator(name)
      (class << self; self; end).module_eval do
        define_method(name) do |*args|
          @pending_annotations ||= []
          @pending_annotations << [name, args]
        end
      end
    end

    def method_added(sym)
      @pending_annotations ||= []
      @pending_annotations.each do |name, args|
        ann sym, name => args
      end
      @pending_annotations = []
      super if defined?(super)
    end

  end

end

# Copyright (c) 2005, 2008 TigerOps

