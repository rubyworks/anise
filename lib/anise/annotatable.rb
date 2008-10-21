module Anise
  require 'anise/annotations.rb'

  # = Annotatable
  #
  # Annotatable allows for the create of dynamic
  # method annotations which attach to the next
  # method defined.
  #
  #   class X
  #     include Anise::Annotatable
  #
  #     annotation :doc
  #
  #     doc "See what I mean?"
  #
  #     def see
  #       # ...
  #     end
  #   end
  #
  #   X.ann(:see, :doc) #=> "See what I mean?"
  #
  # TODO: Thread safety.
  #
  module Annotatable

    def self.append_features(base)
      #if base == Object
      #  Module.send(:include, self)  # FIXME: Module ?
      #else
        base.extend Annotations #unless base.is_a?(Annotations)
        base.extend self
      #end
    end

    def pending_annotations
      @pending_annotations ||= []
    end

    def annotation(name)
      (class << self; self; end).instance_eval do
        define_method(name) do |*args|
          pending_annotations << [name, args]
        end
      end
    end

    def method_added(sym)
      pending_annotations.each do |name, args|
        ann sym, name => args
      end
      @pending_annotations = []
    end

  end

end

# Copyright (c) 2005, 2008 TigerOps

