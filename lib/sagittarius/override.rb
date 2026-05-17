# frozen_string_literal: true

module Sagittarius
  module Override
    extend ActiveSupport::Concern

    class InvalidMethodError < StandardError
    end

    class MissingOverrideError < StandardError
    end

    class_methods do
      def override(method)
        return unless Rails.env.test?

        Override.extensions[self] ||= []
        Override.extensions[self] << method
      end
    end

    def self.verify!(clazz)
      verify_existence!(clazz)
      verify_overrides!(clazz)
    end

    def self.verify_existence!(clazz)
      Override.extensions[clazz].each do |method|
        unless clazz.method_defined?(method)
          raise_error! InvalidMethodError, "Method #{method} is not defined on #{clazz}"
        end
      end
    end

    def self.verify_overrides!(clazz)
      core_class = find_core_class(clazz)
      ext = find_extension(clazz)
      lower_extensions = Sagittarius::Extensions::AVAILABLE_EXTENSIONS.take_while { |e| e != ext }

      valid_sources = [core_class] + lower_extensions.filter_map do |lower_ext|
        mod_name = "#{lower_ext.upcase}::#{clazz.name.delete_prefix("#{ext.upcase}::")}"
        const_get(mod_name) if const_defined?(mod_name)
      end

      Override.extensions[clazz].each do |method|
        unless valid_sources.any? { |src| src.method_defined?(method, false) }
          raise_error! MissingOverrideError, "Method #{method} is not defined on #{core_class} or a lower extension"
        end
      end
    end

    def self.find_core_class(extension_class)
      ext = find_extension(extension_class)
      const_get extension_class.name.delete_prefix("#{ext.upcase}::")
    end

    def self.find_extension(extension_class)
      Sagittarius::Extensions::AVAILABLE_EXTENSIONS.find { |ext| extension_class.name.start_with?("#{ext.upcase}::") }
    end

    def self.extensions
      @extensions ||= {}
    end

    def self.verify_all!
      extensions.each_key { |clazz| verify!(clazz) }
    end

    def self.verify_missing_overrides!(clazz, extended_modules)
      extended_modules.each_with_index do |ext, index|
        lower_sources = [clazz] + extended_modules[0...index]

        ext.instance_methods(false).each do |method|
          source = lower_sources.find { |src| src.method_defined?(method, false) }
          next unless source

          overrides = Override.extensions[ext]
          next if !overrides.nil? && overrides.include?(method)

          raise_error! MissingOverrideError,
                       "Method #{method} in #{ext} overrides #{source} but is not marked as override"
        end
      end
    end

    def self.raise_error!(error, message)
      raise error, message unless defined?(RSpec)

      RSpec::Expectations.fail_with(message)
    end
  end
end
