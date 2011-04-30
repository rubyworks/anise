require 'anise/annotation'
require 'anise/attribute'
require 'anise/annotator'

# = Anise
#
# Dynamic Annotations for Ruby.
#
#   require 'anise'
#
#   class X
#     include Anise
#
#     # Provides annotations
#     ann :foo, :class=>String
#
#     # Provides annotated attributes
#     attr :bar, Integer, :max=>10
#
#     # Provides method annotators.
#     annotator :doc
#     doc "foo is cool"
#     def foo
#       # ...
#     end
#   end
#
module Anise
  extend self 

  def append_features(base)
    #super(base)
    Attribute.append_features(base)
    Annotator.append_features(base)
    base.extend Anise #ClassMethods
  end

  #module ClassMethods
  #  def append_features(base)
  #    super(base)
  #    Attribute.append_features(base)
  #    Annotator.append_features(base)
  #    base.extend ClassMethods
  #  end
  #end

  #
  def self.metadata
    @metadata ||= (
      require 'yaml'
      YAML.load(File.new(File.dirname(__FILE__) + '/anise.yml'))
    )
  end

  #
  def self.const_missing(name)
    metadata[name.to_s.downcase] || super(name)
  end

  VERSION = metadata['version']  # becuase Ruby 1.8~ gets in the way :(
end

