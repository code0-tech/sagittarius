# frozen_string_literal: true

# Heavily inspired by the implementation of GitLab
# (https://gitlab.com/gitlab-org/gitlab/-/blob/d81c871959acc16f2433b44363a2dfa91ed0e362/app/validators/json_schema_validator.rb)
# which is licensed under a modified version of the MIT license which can be found at
# https://gitlab.com/gitlab-org/gitlab/-/blob/d81c871959acc16f2433b44363a2dfa91ed0e362/LICENSE
#
# The code might have been modified to accommodate for the needs of this project
module Sagittarius
  module Validators
    class JsonSchemaValidator < ActiveModel::EachValidator
      FilenameError = Class.new(StandardError)
      BASE_DIRECTORY = %w[app models json_schemas].freeze

      def initialize(options)
        raise ArgumentError, "Expected 'filename' as an argument" unless options[:filename]

        @base_directory = options.delete(:base_directory) || BASE_DIRECTORY

        super
      end

      def validate_each(record, attribute, value)
        value = JSON.parse(JSON.dump(value)) if options[:hash_conversion] == true
        value = JSON.parse(value.to_s) if options[:parse_json] == true && !value.nil?

        if options[:detail_errors]
          begin
            JSON::Validator.validate!(schema_path, value)
          rescue JSON::Schema::ValidationError, JSON::Schema::SchemaError => e
            record.errors.add(attribute, e.message)
          end
        else
          record.errors.add(attribute, error_message) unless valid_schema?(value)
        end
      end

      private

      attr_reader :base_directory

      def format_error_message(error)
        case error['type']
        when 'oneOf'
          format_one_of_error(error)
        else
          error['error']
        end
      end

      def format_one_of_error(error)
        if error['errors'].present?
          error['errors'].map { |e| format_error_message(e) }.join(', ')
        else
          error['error']
        end
      end

      def valid_schema?(value)
        JSON::Validator.validate(schema_path, value, validate_schema: true)
      end

      def schema_path
        @schema_path ||= Rails.root.join(*base_directory, filename_with_extension).to_s
      end

      def filename_with_extension
        "#{options[:filename]}.json"
      end

      def error_message
        options[:message] || 'is not a valid JSON schema'
      end
    end
  end
end
