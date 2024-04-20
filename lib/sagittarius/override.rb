# frozen_string_literal: true

module Sagittarius
  module Override
    extend ActiveSupport::Concern

    InvalidMethodError = Class.new(StandardError)
    MissingOverrideError = Class.new(StandardError)

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
        unless clazz.instance_methods.include?(method)
          raise_error! InvalidMethodError, "Method #{method} is not defined on #{clazz}"
        end
      end
    end

    def self.verify_overrides!(clazz)
      core_class = find_core_class(clazz)

      Override.extensions[clazz].each do |method|
        unless core_class.instance_methods(false).include?(method)
          raise_error! MissingOverrideError, "Method #{method} is not defined on core class #{core_class}"
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
      clazz.instance_methods(false).each do |method|
        extended_modules.each do |ext|
          overrides = Override.extensions[ext]

          next if !overrides.nil? && overrides.include?(method)

          if ext.instance_methods(false).include?(method)
            raise_error! MissingOverrideError, "Method #{method} is not marked as override in #{ext}"
          end
        end
      end
    end

    def self.raise_error!(error, message)
      raise error, message unless defined?(RSpec)

      RSpec::Expectations.fail_with(message)
    end
  end
end
