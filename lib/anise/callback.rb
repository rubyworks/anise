module Anise

  # Callback module ecapsulates all supported callback mixins.
  #
  # Currently the Callbacks module only supports class level callbacks.
  # We will look at adding instance level callbacks in a future version.
  #
  # Here is an example of defining annotating class methods (like 
  # the old Annotator mixin).
  #
  #   class Y
  #     include Anise::Annotation
  #     include Anise::Callbacks
  #
  #     def self.doc(string)
  #       callback :method_added do |method|
  #         self.ann(method, :doc=>string)
  #       end
  #     end
  #
  #     doc "here"
  #
  #     def foo; end
  #   end
  #
  #   Y.ann(:foo, :doc).assert == "here"
  #
  module Callbacks
    #
    def self.append_features(base)
      base.extend self
      base.extend MethodAdded
      base.extend MethodRemoved
      base.extend MethodUndefined
      base.extend SingletonMethodAdded
      base.extend SingletonMethodRemoved
      base.extend SingletonMethodUndefined
      base.extend ConstMissing
      base.extend Included
      base.extend Extended
    end

    #
    def callback(name, &block)
      @_callbacks ||= Hash.new{|h,k| h[k]=[]}
      @_callbacks[name.to_sym] << block
    end

    #
    def callbacks
      @_callbacks ||= Hash.new{|h,k| h[k]=[]}
    end

    # Callback system for #method_added.
    module MethodAdded
      #
      def self.append_features(base)
        base.extend Callbacks
        base.extend self
      end

      #
      def method_added(method)
        @_callbacks[:method_added].each do |block|
          block.call(method)
        end
      end
    end

    # Callback system for #method_removed.
    module MethodRemoved
      #
      def self.append_features(base)
        base.extend Callbacks
        base.extend self
      end

      #
      def method_removed(method)
        callbacks[:method_removed].each do |block|
          block.call(method)
        end
      end
    end

    # Callback system for #method_removed.
    module MethodUndefined
      #
      def self.append_features(base)
        base.extend Callbacks
        base.extend self
      end

      #
      def method_undefined(method)
        callbacks[:method_undefined].each do |block|
          block.call(method)
        end
      end
    end

    # Callback system for #method_added.
    module SingletonMethodAdded
      #
      def self.append_features(base)
        base.extend Callbacks
        base.extend self
      end

      #
      def singleton_method_added(method)
        callbacks[:singleton_method_added].each do |block|
          block.call(method)
        end
      end
    end

    # Callback system for #method_removed.
    module SingletonMethodRemoved
      #
      def self.append_features(base)
        base.extend Callbacks
        base.extend self
      end

      #
      def singleton_method_removed(method)
        callbacks[:singleton_method_removed].each do |block|
          block.call(method)
        end
      end
    end

    # Callback system for #method_removed.
    module SingletonMethodUndefined
      #
      def self.append_features(base)
        base.extend Callbacks
        base.extend self
      end

      #
      def singleton_method_undefined(method)
        callbacks[:singleton_method_undefined].each do |block|
          block.call(method)
        end
      end
    end

    # Callback system for #const_missing.
    module ConstMissing
      #
      def self.append_features(base)
        base.extend Callbacks
        base.extend self
      end

      #
      def const_missing(const)
        callbacks[:const_missing].each do |block|
          block.call(const)
        end
      end
    end

    # Callback system for #included.
    module Included
      #
      def self.append_features(base)
        base.extend Callbacks
        base.extend self
      end

      #
      def included(mod)
        callbacks[:included].each do |block|
          block.call(mod)
        end
      end
    end

    # Callback system for #extended.
    module Extended
      #
      def self.append_features(base)
        base.extend Callbacks
        base.extend self
      end

      #
      def extended(mod)
        callbacks[:extended].each do |block|
          block.call(mod)
        end
      end
    end

    # Callback system for #inherited.
    module Inherited
      #
      def self.append_features(base)
        base.extend Callbacks
        base.extend self
      end

      #
      def extended(mod)
        callbacks[:inherited].each do |block|
          block.call(mod)
        end
      end
    end

  end

end
