require 'anise/annotation'

class Module
  # Define a new annotator.
  #
  def annotator(name=:ann)
    include Anise::Annotation

    module_eval <<-END, __FILE__, __LINE__
      def self.#{name}(ref, *keys)
        annotation_lookup(:#{name}, ref, *keys)
      end
      def self.#{name}!(ref, *keys)
        annotation_lookup!(:#{name}, ref, *keys)
      end
    END
  end
end

# Define a new annotator.
#
def annotator(ns=:ann)
  Object.annotator(ns)
end

