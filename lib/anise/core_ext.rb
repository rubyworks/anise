#require 'facets/inheritor' # removed dependency

class Module
  #
  # Module extension to return attribute methods. These are all methods
  # that start with `attr_`. This method can be overriden in special cases
  # to work with attribute annotations.
  #
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

class Symbol
  #
  # Create new combination symbol with slash.
  #
  # @example
  #   :foo/:bar  #=> :'foo/bar'
  # 
  def /(other)
    "#{self}/#{other}".to_sym
  end
end

class String
  #
  # Create new combination string with slash.
  #
  # @example
  #   'foo'/'bar'  #=> 'foo/bar'
  # 
  def /(other)
    "#{self}/#{other}"
  end
end

# Copyright (c) 2006 Rubyworks. All rights reserved. (BSD-2-Clause License)

