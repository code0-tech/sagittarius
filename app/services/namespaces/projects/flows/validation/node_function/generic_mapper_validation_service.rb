# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      module Validation
        module NodeFunction
          class GenericMapperValidationService
            include Code0::ZeroTrack::Loggable
            include Sagittarius::Database::Transactional

            attr_reader :current_authentication, :flow, :parameter, :generic_mapper

            def initialize(current_authentication, flow, parameter, generic_mapper)
              @current_authentication = current_authentication
              @flow = flow
              @parameter = parameter
              @generic_mapper = generic_mapper
            end

            def execute
              logger.debug("Validating node function: #{parameter.inspect} for flow: #{flow.id}")

              transactional do |t|
                target = generic_mapper.target

                # Validate the target
                unless parameter.generic_type.data_type.generic_keys.has?(target)
                  t.rollback_and_return!(
                    ServiceResponse.error(
                      message: "Generic type #{parameter.generic_type.data_type.id} does not have a generic key for target #{target}",
                      payload: :generic_key_not_found
                    )
                  )
                end

                ::DataType::GenericMapperDataTypeIdentifierValidationService.new(
                  current_authentication,
                  flow,
                  parameter,
                  generic_mapper,
                  generic_mapper.source
                ).execute

              end

              ServiceResponse.success(message: 'Node function generic mapper validation passed')
            end
          end
        end
      end
    end
  end
end
