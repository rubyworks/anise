module Anise

  # Provide all Anise functionality with a single mixin module.
  #
  # @example
  #   class Eg
  #     extend Anise::AnnotationsComplex
  #   end
  #
  module AnnotationsComplex
    include Annotations
    include AnnotatedMethods
    include AnnotatedAttributes
  end

end
