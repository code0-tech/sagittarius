# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      module Validation
        module NodeFunction
          class ReferenceValueValidationService
            include Code0::ZeroTrack::Loggable
            include Sagittarius::Database::Transactional

            attr_reader :current_authentication, :flow, :node, :reference_value

            def initialize(current_authentication, flow, node, reference_value)
              @current_authentication = current_authentication
              @flow = flow
              @node = node
              @reference_value = reference_value
            end

            def execute
              errors = []

              unless reference_value.valid?
                errors << ValidationResult.error(
                  :reference_value_invalid,
                  details: reference_value.errors,
                  location: reference_value
                )
              end

              # https://github.com/code0-tech/sagittarius/issues/508 Validate the usage and datatypes
              errors
            end
          end
        end
      end
    end
  end
end
