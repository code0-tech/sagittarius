# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      module Validation
        class FlowTypeValidationService
          include Code0::ZeroTrack::Loggable
          include Sagittarius::Database::Transactional

          attr_reader :current_authentication, :flow, :flow_type

          def initialize(current_authentication, flow, flow_type)
            @current_authentication = current_authentication
            @flow = flow
            @flow_type = flow_type
          end

          def execute
            logger.debug("Validating flow_type: #{flow_type.inspect} for flow: #{flow.id}")

            transactional do |t|
              if flow_type.runtime != flow.project.primary_runtime
                t.rollback_and_return!(
                  ServiceResponse.error(
                    message: 'Flow type runtime definition does not match the primary runtime of the project',
                    payload: :runtime_mismatch
                  )
                )
              end
            end

          end
        end
      end
    end
  end
end
