require 'anise/annotator'
require 'anise/attribute'

# = Anise
#
# Dynamic Annotations system for Ruby.
#
#   require 'anise'
#
#   class X
#
#     include Anise
#
#     # Provides annotations:
#
#     ann :foo, :class=>String
#
#     # Provides annotators:
#
#     annotator :doc
#     doc "Underdog is here!"
#     def underdog
#       UnderDog.new
#     end
#
#     # Provides annotated attributes:
#
#     attr :bar, Integer, :max => 10
#
#   end
#
module Anise

  def self.append_features(base)
    super(base)
    Attribute.append_features(base)
    Annotator.append_features(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def append_features(base)
      super(base)
      Attribute.append_features(base)
      Annotator.append_features(base)
      base.extend ClassMethods
    end
  end

end

