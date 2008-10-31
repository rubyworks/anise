# = annattr.rb
#
# == Copyright (c) 2005 Thomas Sawyer
#
#   Ruby License
#
#   This module is free software. You may use, modify, and/or redistribute this
#   software under the same terms as Ruby.
#
#   This program is distributed in the hope that it will be useful, but WITHOUT
#   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#   FOR A PARTICULAR PURPOSE.
#
# == Authors & Contributors
#
# * Thomas Sawyer

# Author::    Thomas Sawyer
# Copyright:: Copyright (c) 2005 Thomas Sawyer
# License::   Ruby License

require 'facets/more/inheritor.rb'
require 'facets/yore/annotation.rb'

# = Annotated Attributes
#
# This framework modifies the attr_* methods to allow easy addition of annotations.
# It the built in attribute methods (attr, attr_reader, attr_writer and attr_accessor),
# to allow annotations to added to them directly rather than requireing a separate
# #ann statement.
#
#   class X
#     attr :a, :valid => lambda{ |x| x.is_a?(Integer) }
#   end
#
# See annotation.rb for more information.
#
# NOTE This library was designed to be backward compatible with the
# standard versions of the same methods.

class ::Module

  inheritor :attributes, [], :|

  def attr( *args )
    args.flatten!
    case args.last
    when TrueClass
      args.pop
      attr_accessor( *args )
    when FalseClass
      args.pop
      attr_reader( *args )
    else
      attr_reader( *args )
    end
  end

  code = ''
  [ :_reader, :_writer, :_accessor].each do |m|

    d = case m
    when :_reader
      %{def %1$s; @%1$s; end}
    when :_writer
      %{def %1$s=(x); @%1$s = x; end}
    when :_accessor
      %{def %1$s; @%1$s; end ; def %1$s=(x); @%1$s = x; end}
    else
      %{def %1$s; @%1$s; end}
    end

    code << %{
      def attr#{m}(*args)
        args.flatten!

        harg = {}
        while args.last.is_a?(Hash) ; harg.update(args.pop) ; end

        harg[:class] = args.pop if args.last.is_a?(Class)

        raise if args.empty? and harg.empty?

        if args.empty?
          harg.each { |a,h|
            module_eval( "#{d}" % a)
            a = a.to_sym
            ann(a,h)
          }
          attributes!.concat( harg.keys )  #merge!
          # return the names of the attributes created
          return harg.keys
        else
          args.each { |a|
            module_eval( "#{d}" % a)
            a = a.to_sym
            ann(a,harg)
          }
          attributes!.concat( args )  #merge!
          # return the names of the attributes created
          return args
        end
      end
    }

  end

  class_eval( code )

  alias_method :attribute, :attr_accessor

end



#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

=begin testing

  require 'test/unit'

  class TC01 < Test::Unit::TestCase
    class A
      attr_accessor :x, :cast=>"to_s"
    end

    def test_09_001
      a = A.new
      assert_equal( [:x], A.attributes )
    end
  end

  class TC10 < Test::Unit::TestCase
    class A
      attr :x, :cast=>"to_s"
    end

    def test_10_001
      assert_equal( "to_s", A.ann.x.cast )
    end
  end

=end
