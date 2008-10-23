require 'anise/annotator'
require 'anise/attributes'

# = Anise
#
# Dynamic Annotations system for Ruby.
#
#  class X
#
#    include Anise
#
#    # Provides annotations:
#
#    ann :foo, :class=>String
#
#    # Provides annotators:
#
#    annotator :doc
#    doc "Underdog is here!"
#    def underdog
#      UnderDog.new
#    end
#
#    # Provides annotated attributes:
#
#    attr :bar, Integer, :max => 10
#
#  end
#
module Anise

  def self.append_features(base)
    Attributes.append_features(base)
    Annotator.append_features(base)
  end

end

