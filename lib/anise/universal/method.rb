# DEPRECATED

require 'anise/method'

class Module
  # Define a new method annotation.
  #
  # @param name [Symbol]
  #   Name of annotation.
  #
  # @param ns [Symbol]
  #   Annotator "namespace". Default is `:ann`.
  #
  def method_annotator(name, ns=:ann, &block)
    include Anise::Method

    # setup annotator
    annotator ns

    #(class << self; self; end).module_eval do
      define_method(name) do |*args|
        @_pending_annotations ||= []
        @_pending_annotations << [name, ns, args, block]
      end
    #end
  end
end

# Define a new method annotation.
#
# @param name [Symbol]
#   Name of annotation.
#
# @param ns [Symbol]
#   Annotator "namespace". Default is `:ann`.
#
def method_annotator(name, ns=:ann, &block)
  Object.method_annotator(name, ns, &block)
end

# Copyright (c) 2005,2011 Thomas Sawyer. All rights reserved. (BSD 2 License)
