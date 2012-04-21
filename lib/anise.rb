# Dynamic Annotations for Ruby.
#
#   require 'anise'
#
# Provides annotations:
#
#   class X
#     extend Anise::Annotations
#
#     ann :foo, :class=>String
#   end
#
# Provides method annotations:
#
#   class Y
#     extend Anise::Annotator::Method
#
#     def self.doc(string)
#       method_annotation(:doc=>string)
#     end
#
#     doc "foo is cool"
#     def foo
#       # ...
#     end
#   end
#
# Provides annotated attributes:
#
#   class Z
#     extend Anise::Annotator::Attribute
#
#     attr :bar, Integer, :max=>10
#   end
#
module Anise
  require 'anise/version'
  require 'anise/core_ext'
  require 'anise/annotations'
  require 'anise/annotations/store'
  require 'anise/annotative'
  require 'anise/annotative/methods'
  require 'anise/annotative/attributes'
  require 'anise/annotative/variables'
end
