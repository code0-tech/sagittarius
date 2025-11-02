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
              errors = []
              errors += ::DataType::DataTypeValidationService.new(
                current_authentication,
                flow,
                generic_type.data_type
              ).execute

              generic_type.generic_mappers.each do |generic_mapper|
                errors += ::DataType::GenericMapperValidationService.new(
                  current_authentication,
                  flow,
                  parameter,
                  generic_mapper
                ).execute
              end
              errors
            end
          end
        end
      end
    end
  end
end
