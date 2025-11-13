# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      module Validation
        class FlowValidationErrorCode
          InvalidErrorCode = Class.new(StandardError)

          def self.validate_error_code!(error_code)
            return unless error_code.is_a?(Symbol)
            return if Rails.env.production?

            raise InvalidErrorCode, error_code unless error_codes.include?(error_code)
          end

          # rubocop:disable Layout/LineLength -- We want each description on a single line for readability
          def self.error_codes
            {
              data_type_identifier_runtime_mismatch: { description: 'The data type identifier runtime does not match the flow type runtime.' },
              data_type_identifier_generic_key_not_found: { description: 'The generic key for the data type identifier was not found.' },
              data_type_rule_model_invalid: { description: 'The data type rule model is invalid.' },
              data_type_runtime_mismatch: { description: 'The data type runtime does not match the flow type runtime.' },
              flow_setting_model_invalid: { description: 'The flow setting model is invalid.' },
              flow_type_runtime_mismatch: { description: 'The flow type runtime does not match the project primary runtime.' },
              no_primary_runtime: { description: 'The project does not have a primary runtime set.' },
              node_function_runtime_mismatch: { description: 'The node function runtime does not match the project primary runtime.' },
            }
          end
          # rubocop:enable Layout/LineLength
        end
      end
    end
  end
end
