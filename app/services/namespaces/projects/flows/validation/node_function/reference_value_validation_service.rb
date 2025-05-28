# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      module Validation
        module NodeFunction
          class ReferenceValueValidationService
            include Code0::ZeroTrack::Loggable
            include Sagittarius::Database::Transactional

            attr_reader :current_authentication, :flow, :node_function

            def initialize(current_authentication, flow, node_function)
              @current_authentication = current_authentication
              @flow = flow
              @node_function = node_function
            end

            def execute
              transactional do |t|
                ::DataType::DataTypeIdentifierValidationService.new(
                  current_authentication,
                  flow,
                  node_function,
                  parameter.reference_value.data_type_identifier
                ).execute

                identifier = parameter.reference_value.data_type_identifier

                if identifier.generic_key.present?
                  t.rollback_and_return!(
                    ServiceResponse.error(
                      message: 'Data type identifier cannot have a generic key in a function',
                      payload: :generic_key_present
                    )
                  )
                end

                if identifier.generic_type.present?
                  GenericTypeValidationService.new(
                    current_authentication,
                    flow,
                    node_function,
                    identifier.generic_type
                  ).execute
                end
              end
            end
          end
        end
      end
    end
  end
end
