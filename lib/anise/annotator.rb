module Anise

  # TODO: The ann(x).name notation is kind of nice. Would like to add that
  #       back-in if reasonable.

  # The Annotator class is parametric mixin which is used to create custom
  # annotors akin to the standard `:ann` annotator. The name of the annotator
  # can be any symbol.
  #
  #   require 'anise/annotator'
  #
  #   class X
  #     include Annotator[:cool]
  #
  #     cool :a, :desc => "Awesome!"
  #   end
  #
  #   X.cool(:a, :desc) #=> "Awesome!"
  #
  class Annotator < Module

    #
    # Convenience method for #new.
    #
    def self.[](name)
      new(name)
    end

    #
    # Initialize new annotator.
    #
    # @param [Symbol] name
    #   Annotator method name.
    #
    def initialize(name)
      @name = name.to_sym

      module_eval <<-END, __FILE__, __LINE__
        def #{ns}(ref, *keys)
          if keys.empty?
            annotations.lookup(ref, :#{ns})
          else
            annotations.annotate(:#{ns}, ref, *keys)
          end
        end
        def #{ns}!(ref, *keys)
          if keys.empty?
            annotations[ref, :#{ns}]
          else
            annotations.annotate!(:#{ns}, ref, *keys)
          end
        end
      END
    end

    #
    # Include is converted to an extend.
    #
    def append_features(base)
    end

    #
    # When included into a class or module, it actually extends that class
    # or module. {AnnotationAccessors} also extends the class or module.
    #
    # @param base [Class, Module]
    #   The class or module to get features.
    #
    def included(base)
      base.extend AnnotationAccessors
      base.extend self
    end

  end

  #
  # Convenience method for `Annotator.new`.
  #
  def self.Annotator(name)
    Annotator.new(name)
  end

end

# Copyright (c) 2006 Rubyworks. All rights reserved. (BSD-2-Clause License)
