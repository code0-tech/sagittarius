# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      module Validation
        class ValidationResult
          def self.typo(error_code, details = nil)
            new(type: :typo, error_code: error_code, details: details)
          end

          def self.error(error_code, details = nil)
            new(type: :error, error_code: error_code, details: details)
          end

          def self.weak(error_code, details = nil)
            new(type: :weak, error_code: error_code, details: details)
          end

          def self.warning(error_code, details = nil)
            new(type: :warning, error_code: error_code, details: details)
          end

          attr_reader :type, :error_code, :details

          def initialize(type:, error_code:, details:)
            @type = type
            @error_code = error_code
            @details = details
          end
        end
      end
    end
  end
end
