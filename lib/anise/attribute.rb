module Anise
  #require 'facets/inheritor' # removed dependency
  require 'anise/annotation'
  require 'anise/module'

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
      super(base)
      Annotation.append_features(base)
      base.extend ClassMethods #Attribute

      #inheritor :instance_attributes, [], :|
      base_class = (class << base; self; end)
      base_class.attribute_methods.each do |attr_method|
        annotatable_attribute_method(base_class, attr_method)
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

    # Anise::Attributes Doman Language.
    module ClassMethods

      # Instance attributes, including inherited attributes.
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

end

# Copyright (c) 2005, 2008 Thomas Sawyer
