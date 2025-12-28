# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      module Validation
        class ValidationResult
          def self.typo(error_code, location:, details: nil)
            new(severity: :typo, error_code: error_code, details: details, location: location)
          end

          def self.error(error_code, location:, details: nil)
            new(severity: :error, error_code: error_code, details: details, location: location)
          end

          def self.weak(error_code, location:, details: nil)
            new(severity: :weak, error_code: error_code, details: details, location: location)
          end

          def self.warning(error_code, location:, details: nil)
            new(severity: :warning, error_code: error_code, details: details, location: location)
          end

          attr_reader :severity, :error_code, :details, :location

          def initialize(severity:, error_code:, details:, location:)
            FlowValidationErrorCode.validate_error_code!(error_code)

            @severity = severity
            @error_code = error_code
            @details = details
            @location = location
          end
        end
      end
    end
  end
end
