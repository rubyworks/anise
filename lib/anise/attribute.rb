#require 'facets/inheritor' # remove dependency

module Anise
  require 'anise/annotation'

  # = Annotated Attributes
  #
  # This framework modifies the major attr_* methods to allow easy
  # addition of annotations. It modifies the built in attribute methods
  # (attr, attr_reader, attr_writer and attr_accessor), to allow
  # annotations to be added to them directly rather than requiring
  # a separate #ann statement.
  #
  #   require 'anise/attribute'
  #
  #   class X
  #     include Anise::Attribute
  #
  #     attr :a, :valid => lambda{ |x| x.is_a?(Integer) }
  #   end
  #
  # See annotation.rb for more information.
  #
  # NOTE: This library was designed to be backward compatible with
  # the standard versions of the same methods.
  #
  module Attribute

    #
    def self.append_features(base)
      if base == ::Object
        append_features(::Module)
      elsif base == ::Module
        unless ::Module <= self
          ::Module.module_eval do
            include Annotation
            super(::Module)
          end
          ::Module.attribute_methods.each do |attr_method|
            annotatable_attribute_method_for_module(attr_method)
          end
          #annotatable_attribute_method_for_module(:attr)
          #annotatable_attribute_method_for_module(:attr_reader)
          #annotatable_attribute_method_for_module(:attr_writer)
          #annotatable_attribute_method_for_module(:attr_accessor)
          #annotatable_attribute_method_for_module(:attr_setter) if defined?(attr_setter)
        end
      else
        base.extend Annotation
        base.extend Attribute
        base = (class << base; self; end)
        #inheritor :instance_attributes, [], :|
        base.attribute_methods.each do |attr_method|
          annotatable_attribute_method(base, attr_method)
        end
        #annotatable_attribute_method(base, :attr)
        #annotatable_attribute_method(base, :attr_reader)
        #annotatable_attribute_method(base, :attr_writer)
        #annotatable_attribute_method(base, :attr_accessor)
        #annotatable_attribute_method(base, :attr_setter) if defined?(attr_setter)
      end
    end

    #
    def self.annotatable_attribute_method(base, attr_method_name)
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

            #attr_method.call(*args)
            super(*args)

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
    def self.annotatable_attribute_method_for_module(attr_method_name)
      ::Module.module_eval do
        alias_method "__#{attr_method_name}", attr_method_name

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

            __send__("__#{attr_method_name}", *args)

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

    # Instance attributes, including inherited attributes.
    def instance_attributes
      a = []
      ancestors.each do |anc|
        next unless anc.is_a?(Attribute)
        if x = anc.instance_attributes!
          a |= x
        end
      end
      return a
    end

    # Local instance attributes.
    def instance_attributes!
      @instance_attributes ||= []
    end

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

    # This define a simple adjustment to #attr to allow it to handle the boolean argument and
    # to be able to accept attributes. It's backward compatible and is not needed for Ruby 1.9
    # which gets rid of the secondary argument.
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

class Module
  # Module extension to return attribute methods. These are all methods
  # that start with `attr_`. This method can be overriden in special cases
  # to work with the attribute annotations.
  def attribute_methods
    list = []
    public_methods(true).each do |m|
      list << m if m.to_s =~ /^attr_/
    end
    protected_methods(true).each do |m|
      list << m if m.to_s =~ /^attr_/
    end
    private_methods(true).each do |m|
      list << m if m.to_s =~ /^attr_/
    end
    return list
  end
end

# Copyright (c) 2005, 2008 Thomas Sawyer
