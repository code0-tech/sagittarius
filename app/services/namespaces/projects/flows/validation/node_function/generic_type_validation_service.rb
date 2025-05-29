# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      module Validation
        module NodeFunction
          class GenericTypeValidationService
            include Code0::ZeroTrack::Loggable
            include Sagittarius::Database::Transactional

            attr_reader :current_authentication, :flow, :node_function, :generic_type

            def initialize(current_authentication, flow, node_function, generic_type)
              @current_authentication = current_authentication
              @flow = flow
              @node_function = node_function
              @generic_type = generic_type
            end

            def execute
              transactional do |_t|
                ::DataType::DataTypeValidationService.new(
                  current_authentication,
                  flow,
                  identifier.data_type
                ).execute

                identifier.data_type.generic_mappers.each do |generic_mapper|
                  logger.debug("Validating generic mapper: #{generic_mapper.id}" \
                               "for data type identifier: #{identifier.id}")
                  ::DataType::GenericMapperValidationService.new(
                    current_authentication,
                    flow,
                    parameter,
                    generic_mapper
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
