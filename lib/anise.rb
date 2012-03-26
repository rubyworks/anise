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
#     extend Anise::MethodAnnotations
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
#     extend Anise::Attributes
#
#     attr :bar, Integer, :max=>10
#   end
#
module Anise

  require 'anise/version'
  require 'anise/core_ext'
  require 'anise/store'
  require 'anise/annotations'
  require 'anise/methods'
  require 'anise/attributes'
  require 'anise/complex'

end
