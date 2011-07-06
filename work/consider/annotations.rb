# Ultimately it might be nice to replace the general hashes used to
# store annotations with something more sophisticated. The main benefit
# being that we could control in-place operations, so that the need for
# a normal and a bang method wiould not be needed (e.g. #ann and #ann!).

module Anise

  class Namespaces
    #
    def initialize(base)
      @base       = base
      @table      = {}
    end

    #
    def [](ns)
      @table[ns] || ancestor[ns]
    end

    #
    def to_h
      ann = {}
      ancestors.reverse_each do |anc|
        next unless anc < Annotator
        if h = anc.annotations[ns][ref]
          ann.merge!(h)
        end
      end
    end

    #
    def ancestor
      @base.ancestors[1].namespaces
    end

  end

  class References
    #
    def initialize(namespace)
      @namespace   = namespace
      @table       = {}
    end

    #
    def [](ref)
      @table[ref] || ancestor[ref]
    end
  end

  class Annotations
    #
    def initialize(parent)
      @parent = parent  # Reference
      @table  = {}
    end

    #
    def [](key)
      @table[key] || ancestor[key]
    end

    #
    def update(hash)
      hash.each do |k,v|
        @table[k] = v
      end
    end

    #
    def to_h
      ancestor.to_h.merge(@table)
    end

    private

    def ancestor
      
    end

  end

end
