# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      module Validation
        class ValidationResult
          def self.typo(error_code, details = nil)
            new(severity: :typo, error_code: error_code, details: details)
          end

          def self.error(error_code, details = nil)
            new(severity: :error, error_code: error_code, details: details)
          end

          def self.weak(error_code, details = nil)
            new(severity: :weak, error_code: error_code, details: details)
          end

          def self.warning(error_code, details = nil)
            new(severity: :warning, error_code: error_code, details: details)
          end

          attr_reader :severity, :error_code, :details

          def initialize(severity:, error_code:, details:)
            FlowValidationErrorCode.validate_error_code!(error_code)

            @severity = severity
            @error_code = error_code
            @details = details
          end
        end
      end
    end
  end
end
