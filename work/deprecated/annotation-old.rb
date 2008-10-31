# = annotation.rb
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

require 'facets/core/hash/to_h'
require 'facets/core/kernel/object_class'
require 'facets/more/openobject'
#require 'facets/more/nullclass'

# = Annotation
#
# Annotations allows you to annontate objects, including methods with arbitrary
# "metadata". These annotations don't do anything in themselves. They are
# merely comments. But you can put them to use. For instance an attribute
# validator might check for an annotation called :valid and test against it.
#
# Annotation is an OpenObject, and is used across the board for keeping annotations.
#
# Annotation class serves for both simple and inherited cases depending on whether
# a base class is given.
#
# == Synopsis
#
#   class X
#     attr :a
#     ann :@a, :valid => lambda{ |x| x.is_a?(Integer) }
#
#     def validate
#       instance_variables.each { |iv|
#         if validator = self.class.ann(iv)[:valid]
#           value = instance_variable_get(iv)
#           unless validator.call(vale)
#             raise "Invalid value #{value} for #{iv}"
#           end
#         end
#       }
#     end
#
#   end

class Annotations

  def initialize( base )
    @base, @ann = base, {}
  end

  def [](key)
    key = :self if key == @base
    @ann[key] ||= Annotation.new(@base, key)
  end

  def []=(key, note)
    raise ArgumentError unless Annotation === note
    @ann[key] = note
  end

  def ==(other) @ann == other.to_h end

  def to_h() @ann end

  def key?(key) @ann.key?(key) end

  def each(&yld)
    @ann.each(&yld)
  end

  def update( other )
    @ann.update( other.to_h )
    self
  end
  private :update

  def self
    self[:self]
  end

#   def inheritance
#     anns = Annotations.new(@base)
#     @base.ancestors.each do |anc|
#       anc.annotations.each { |k,v|
#         next if anns.key?(k)
#         anns[k] = v #.dup
#       }
#     end
#     #@ann.each_key do |name|
#     #  anns[name] = self[name].heritage
#     #end
#     return anns
#   end

  def annotated_base() @base end

  def method_missing( key, *args, &blk )
    if key?(key)
      self[key] #.heritage
    else
      if @base.ancestors.any?{|anc| anc.annotations.key?(key)}
        return self[key].heritage
        #ann[name].heritage
      end
      super
    end
  end

end

#

class Annotation < OpenObject

  def initialize( base, key, orig=nil )
    @base = base
    @key  = key
    @orig = orig || self
    super()
  end

  def original
    @orig
  end

  #def class
  #  self[:class]
  #end

  def inspect
    "#<#{object_class.name}(#{@base}##{@key}) #{super}>"
  end

  def annotation_key
    @key
  end

  def heritage( orig=nil )
    ah = {}
    @base.ancestors.reverse_each do |anc|
      if anc.annotations.key?(@key)
        anc.annotations[@key].each { |k,v|
          case v
          when Module
            ah[k] = v
          else
            ah[k] = v.dup rescue v
          end
        }
      end
    end
    a = Annotation.new( @base, @key, orig || @orig )
    a.send(:replace, ah)
    a
  end

  def method_missing( sym, *args, &blk )
    type = sym.to_s[-1,1]
    key = sym.to_s.gsub(/[=!?]$/, '').to_sym

    case type
    when '='
      @orig[key] = args[0] #, *args, &blk )
    when '!'
      #r = super( key, *args, &blk )
      if key?(key)
        self[key]
      else
        self[key] = heritage(self)[key]
      end
    else
      heritage[sym]
    end
  end

end

#

class Module

  def annotations
    @annotations ||= Annotations.new(self)
  end

  def ann( key=nil, *options )
    return annotations unless key
    return name.collect{|k,v| ann k,*v} if Hash === key
    return annotations[key] if options.empty?
    opt = {}
    opt.update options.pop if Hash === options.last
    opt[:class] = options.pop if Class === options.last
    keys = [key].concat options
    keys.each do |key|
      note = annotations[key]
      #unless options.empty?
      #  (hopt[:tags] ||= []) << options
      #end
      note.send(:update,opt)
    end
    keys
  end

end


# Any object can be annotated.

module Kernel

  #--
  # Store and retrieve annotations for an object.
  #def annotation( harg=nil )
  #  @_annotation ||= Annotation.new
  #  return @_annotation unless harg
  #  @_annotation.send(:update, harg)
  #end
  #++

  #--
  # Not sure about this.
  #++
  def ann( *args )
    #if singleton_class?
      (class << self; self; end).ann( *args )
    #else
    #  self.class.ann( *args )
    #end
  end

end


#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |_
#   |_|\___||___/\__|
#

=begin test

  require 'test/unit'

  class TestAnnotation1 < Test::Unit::TestCase
    class X
      def x1 ; end
      ann :x1, :a=>1
      ann :x1, :b=>2
    end

    def test_1_01
      assert_equal(X.ann.x1.orig.object_id, X.ann.x1.orig.object_id)
    end
    def test_1_02
      X.ann.x1.a = 2
      assert_equal(2, X.ann.x1.a)
    end
  end

  class TestAnnotation2 < Test::Unit::TestCase
    class X
      def x1 ; end
      ann :x1, :a=>1
      ann :x1, :b=>2
    end
    class Y < X ; end

    def test_2_01
      assert_equal(Y.ann.x1.original.object_id, Y.ann.x1.original.object_id)
    end
    def test_2_02
      assert_equal(1, Y.ann.x1.a)
      assert_equal(2, Y.ann.x1.b)
    end
    def test_2_03
      Y.ann.x1.a = 2
      assert_equal(2, Y.ann.x1.a)
      assert_equal(2, Y.ann.x1.b)
    end
  end

  class TestAnnotation3 < Test::Unit::TestCase
    class X
      def x1 ; end
      ann :x1, :a=>1
      ann :x1, :b=>2
    end
    class Y < X
      ann :x1, :y=>'Y'
    end

    def test_3_01
      assert_equal(Y.ann.x1.original.object_id, Y.ann.x1.original.object_id)
    end
    def test_3_02
      assert_equal(1, Y.ann.x1.a)
    end
    def test_3_03
      Y.ann.x1.a = 2
      assert_equal(2, Y.ann.x1.a)
    end
  end

  class TestAnnotation4 < Test::Unit::TestCase
    module M
      def x1 ; end
      ann :x1, :a=>1
      ann :x1, :b=>2
    end
    class X
      include M
    end

    def test_4_01
      assert_equal(X.ann.x1.original.object_id, X.ann.x1.original.object_id)
    end
    def test_4_02
      assert_equal(1, X.ann.x1.a)
      assert_equal(2, X.ann.x1.b)
    end
    def test_4_03
      X.ann.x1.a = 2
      assert_equal(2, X.ann.x1.a)
    end
  end

  class TestAnnotation5 < Test::Unit::TestCase
    class X
      ann :foo, :doc => "hello"
      ann :foo, :bar => []
    end
    class Y < X
      ann :foo, :class => String, :doc => "bye"
    end

    def test_5_01
      assert_equal( "hello", X.ann(:foo).doc )
    end
    def test_5_02
      assert_equal( X.ann(:foo), X.ann.foo )
    end
    def test_5_03
      X.ann(:foo).bar! << "1"
      assert_equal( ["1"], X.ann.foo.bar )
    end
    def test_5_04
      assert_equal( "bye", Y.ann(:foo).doc )
    end
    def test_5_05
      #assert_equal( nil, Y.ann(:foo).bar )
      assert_equal( ["1"], Y.ann(:foo).bar )
    end
    def test_5_06
      Y.ann(:foo).doc = "cap"
      assert_equal( "cap", Y.ann(:foo).doc  )
    end
    def test_5_07
      Y.ann.foo.doc = "cap2"
      assert_equal( "cap2", Y.ann(:foo).doc  )
    end
    def test_5_08
      Y.ann(:foo).bar! << "2"
      assert_equal( ["1", "2"], Y.ann(:foo).bar )
      assert_equal( ["1", "2"], Y.ann(:foo).bar! )
      assert_equal( ["1"], X.ann(:foo).bar )
    end
  end

  # Test non-existent elements.

  class TestAnnotation6 < Test::Unit::TestCase
    class X
      def x1 ; end
      ann :x1, :a=>1, :b=>2
    end

    def test_6_01
      assert_equal( 1, X.ann(:x1)[:a] )
      assert_equal( 2, X.ann(:x1)[:b] )
      assert_equal( {}, X.ann(:x2) )
    end
    def test_6_02
      assert_equal( 1, X.ann(:x1)[:a] )
      assert_equal( 2, X.ann(:x1)[:b] )
      assert_equal( nil, X.ann(:x1)[:c] )
    end
    def test_6_03
      assert_equal( 1, X.ann.x1[:a] )
      assert_equal( 2, X.ann.x1[:b] )
    end
    def test_6_04
      assert_equal( 1, X.ann.x1.a )
      assert_equal( 2, X.ann.x1.b )
    end
    def test_6_05
      assert_equal( {}, X.ann.x2 )
      assert_equal( nil, X.ann.x1.r )
    end
  end

  class TestAnnotation7 < Test::Unit::TestCase
    class X
      def x ; end
      ann :x, :z=>1
    end
    class Y < X ; end

    def test_7_04
      assert_equal(1, X.ann(:x)[:z])
      assert_equal(nil, Y.ann(:x)[:z])
      assert_equal(1, Y.ann(:x).z)
    end
    def test_7_05
      assert_equal(1, X.ann.x[:z])
      assert_equal(nil, Y.ann.x[:z])
      assert_equal(1, Y.ann.x.z)
    end
    def test_7_06
      Y.ann.x.z = 2
      assert_equal(2, Y.ann.x.z)
    end
  end

  class TestAnnotation8 < Test::Unit::TestCase
    class X
      def n ; end
      ann :n, :v=>1
      ann :n, :p=>3
    end
    class Y < X
      ann :n, :b=>2
    end

    def test_08_01
      assert_equal(2, Y.ann(:n)[:b])
      assert_equal(nil, Y.ann(:n)[:v])
      assert_equal(1, Y.ann(:n).v)
    end
    def test_08_02
      assert_equal(2, Y.ann(:n).b)
    end
    def test_08_03
      assert_equal(2, Y.ann.n.b)
    end
  end

  class TestAnnotation9 < Test::Unit::TestCase
    module M
      ann :a, String
      ann :b, :foo=>3
    end

    def test_09_01
      assert_equal( String, M.ann.a[:class] )
    end
    def test_09_02
      assert_equal( String, M.ann.a.class )
    end
    def test_09_03
      assert_equal(3, M.ann.b.foo)
    end
  end

  class TestAnnotation10 < Test::Unit::TestCase
    class C
      ann :self, :mod => 'YES'
    end
    def test_10_01
      assert_equal( 'YES', C.ann.self.mod )
    end
  end

#   class TestAnnotation10 < Test::Unit::TestCase
#     module M
#       ann :this, :koko => []
#       ann.this.koko! << 1
#     end
#     class C1
#       #ann :this, :koko => []
#       include M
#       ann.this.koko! << 2
#       ann.this.koko! << 3
#     end
#     class C2
#       include M
#       ann.this.koko! << 4
#     end
#
#     def test_10_01
#       assert_equal( [1], M.ann.this.koko )
#     end
#     def test_10_02
#       assert_equal( [1,2,3], C1.ann.this.koko )
#     end
#     def test_10_03
#       assert_equal( [1,4], C2.ann.this.koko )
#     end
#   end

#   class TC07 < Test::Unit::TestCase
#     class K
#       ann self, :oid => 'key'
#       ann :w, String
#     end
# 
#     def test_07_001
#       assert_equal( String, K.ann.w.class )
#     end
# 
#     def test_07_002
#       assert_equal( 'key', K.ann.self.oid )
#     end
# 
#     def test_07_003
#       #assert_equal( K.ann.self, K.ann(:self) )
#       #assert_equal( K.ann(K), K.annotation )
#       #assert_equal( K.ann.self.to_h, K.ann(K).to_h )
#       #assert_equal( K.ann.self, K.ann(K) )
#     end
#   end
# 

#  class TestAnnotation7 < Test::Unit::TestCase

#     class X
#       def x ; end
#       ann :x, :z=>1
#     end
#     class Y < X ; end
#
#     def test_7_01
#       assert( Y.annotated?(:x) )
#     end
#     def test_7_02
#       assert_equal( [:x1], Y.annotated_methods )
#     end
#     def test_7_03
#       assert_equal( 1, Y.ann(:x).inheritance )
#       assert_equal( 1, Y.ann(:x) )
#     end
#   end


=end
