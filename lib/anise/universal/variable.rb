require 'anise/variable'

class Module
  # Start method annotations.
  #
  # @param ns [Symbol]
  #   Annotator "namespace". Default is `:ann`.
  #
  def annotate(ns=:ann, &block)
    include Anise::Annotate

    annotator ns  # setup annotator

    @_annotation_space = ns
    @_annotation_block = block
    @_annotation_state = instance_variables
  end
end

# Start method annotations.
#
# @param ns [Symbol]
#   Annotator "namespace". Default is `:ann`.
#
def annotate(ns=:ann, &block)
  Object.annotate(ns, &block)
end

# Copyright (c) 2005,2011 Thomas Sawyer. All rights reserved. (BSD 2 License)
