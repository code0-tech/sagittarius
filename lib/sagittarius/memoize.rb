# frozen_string_literal: true

module Sagittarius
  module Memoize
    def memoize(name, reset_on_change: nil)
      unless reset_on_change.nil?
        reset_trigger = reset_on_change.call
        reset_memoize = memoize("#{name}_reset_on_change") { reset_trigger }

        if reset_trigger != reset_memoize
          clear_memoize(name)
          clear_memoize("#{name}_reset_on_change")
        end
      end

      if memoized?(name)
        instance_variable_get(ivar(name))
      else
        instance_variable_set(ivar(name), yield)
      end
    end

    def memoized?(name)
      instance_variable_defined?(ivar(name))
    end

    def clear_memoize(name)
      clear_memoize!(name) if memoized?(name)
    end

    def clear_memoize!(name)
      remove_instance_variable(ivar(name))
    end

    private

    def ivar(name)
      case name
      when Symbol
        name.to_s.prepend('@').to_sym
      when String
        :"@#{name}"
      else
        raise ArgumentError, "Invalid type of '#{name}'"
      end
    end
  end
end
