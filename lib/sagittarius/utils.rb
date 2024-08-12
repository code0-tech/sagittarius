# frozen_string_literal: true

module Sagittarius
  module Utils
    module_function

    def to_boolean(value, default: nil)
      value = value.to_s if [0, 1].include?(value)

      return value if [true, false].include?(value)
      return true if value =~ /^(true|t|yes|y|1|on)$/i
      return false if value =~ /^(false|f|no|n|0|off)$/i

      default
    end

    # Returns the current monotonic clock time as seconds with microseconds precision
    def monotonic_time
      Process.clock_gettime(Process::CLOCK_MONOTONIC, :float_second)
    end
  end
end
