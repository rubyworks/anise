module Anise

  # AnnotatedAttributes modifies the attr_* methods to allow easy
  # addition of annotations for attributes. It modifies the built in
  # attribute methods (attr, attr_reader, attr_writer and attr_accessor),
  # and any other custom `attr_*` methods, to allow annotations to be
  # added to them directly rather than requiring a separate annotating
  # statement.
  #
  #   require 'anise/attribute'
  #
  #   class X
  #     include Anise::AnnotatedAttributes
  #
  #     attr :a, :valid => lambda{ |x| x.is_a?(Integer) }
  #   end
  #
  # See {Annotation} module for more information.
  #
  # @todo Currently annotated attributes alwasy use the standard
  #       annotator (:ann). In the future we might make this customizable.
  #
  module AnnotatedAttributes
    include Annotations

    #
    # When included into a class or module, {Annotation} is also
    # included and {Attribute::Aid} extends the class/module.
    #
    # @param base [Class, Module]
    #   The class or module to get features.
    #
    def self.extended(base)
      #inheritor :instance_attributes, [], :|
      base_class = (class << base; self; end)
      #base_class.attribute_methods.each do |attr_method|
      base.attribute_methods.each do |attr_method|
        define_annotated_attribute(base_class, attr_method)
      end
    end

    # TODO: Might #define_annotated_attribute make an acceptable class extension?

    #
    # Define an annotated attribute method, given an existing
    # non-annotated attribute method.
    #
    def self.define_annotated_attribute(base, attr_method_name)
      base.module_eval do
        define_method(attr_method_name) do |*args|
          args.flatten!

          harg={}; while args.last.is_a?(Hash)
            harg.update(args.pop)
          end

          raise ArgumentError if args.empty? and harg.empty?

          if args.empty?  # hash mode
            harg.each { |a,h| __send__(attr_method_name,a,h) }
          else
            klass = harg[:class] = args.pop if args.last.is_a?(Class)

            super(*args) #attr_method.call(*args)

            args.each{|a| ann(a.to_sym,harg)}

            instance_attributes!.concat(args)  #merge!

            # Use this callback to customize for your needs.
            if respond_to?(:attr_callback)
              attr_callback(self, args, harg)
            end

            # return the names of the attributes created
            return args
          end
        end
      end
    end

    #
    # Instance attributes, including inherited attributes.
    #
    def instance_attributes
      a = []
      ancestors.each do |anc|
        next unless anc < Attribute
        if x = anc.instance_attributes!
          a |= x
        end
      end
      return a
    end

    #
    # Local instance attributes.
    #
    def instance_attributes!
      @instance_attributes ||= []
    end

    #
    # Return list of attributes that have a :class annotation.
    #
    #   class MyClass
    #     attr_accessor :test
    #     attr_accessor :name, String, :doc => 'Hello'
    #     attr_accessor :age, Fixnum
    #   end
    #
    #   MyClass.instance_attributes # => [:test, :name, :age, :body]
    #   MyClass.classified_attributes # => [:name, :age]
    #
    def classified_attributes
      instance_attributes.find_all do |a|
        self.ann(a, :class)
      end
    end

    #
    # This defines a simple adjustment to #attr to allow it to handle the boolean argument and
    # to be able to accept attributes. It's backward compatible and is not needed for Ruby 1.9
    # which gets rid of the secondary argument (or was suppose to!).
    #
    def attr(*args)
      args.flatten!
      case args.last
      when TrueClass
        args.pop
        attr_accessor(*args)
      when FalseClass, NilClass
        args.pop
        attr_reader(*args)
      else
        attr_reader(*args)
      end
    end

  end

end

# Copyright (c) 2006,2011 Thomas Sawyer. All rights reserved. (BSD-2-Clause License)
