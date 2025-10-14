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
              logger.debug("Validating generic mapper: #{generic_mapper.inspect} for flow: #{flow.id}")

              transactional do |t|
                target = generic_mapper.target

                # Validate the target the identifier gets validated later
                unless parameter.node_function.runtime_function.generic_keys.include?(target)
                  t.rollback_and_return!(
                    ServiceResponse.error(
                      message: "Runtime function definition #{parameter.node_function.runtime_function} " \
                               "does not have a generic key for target #{target}",
                      payload: :generic_key_not_found
                    )
                  )
                end

                generic_mapper.generic_combination_strategies.each do |_strategy|
                  # https://github.com/code0-tech/sagittarius/issues/509
                end

                generic_mapper.sources.each do |source|
                  Namespaces::Projects::Flows::Validation::DataType::DataTypeIdentifierValidationService.new(
                    current_authentication,
                    flow,
                    parameter.node_function,
                    source
                  ).execute
                end
              end
              nil
            end
          end
        end
      end
    end
  end
end
