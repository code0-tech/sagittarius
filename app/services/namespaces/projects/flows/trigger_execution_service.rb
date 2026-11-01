# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      class TriggerExecutionService
        include Code0::ZeroTrack::Loggable

        attr_reader :current_authentication, :flow, :runtime, :input

        def initialize(current_authentication, flow:, runtime:, input:)
          @current_authentication = current_authentication
          @flow = flow
          @runtime = runtime
          @input = input
        end

        def execute
          unless Ability.allowed?(current_authentication, :trigger_execution, flow)
            return ServiceResponse.error(message: 'Missing permission', error_code: :missing_permission)
          end

          execution_identifier = SecureRandom.uuid

          execution_request = Tucana::Sagittarius::Gateway::TestExecutionRequest.new(
            flow_id: flow.id,
            execution_identifier: execution_identifier,
            body: Tucana::Shared::Value.from_ruby(input)
          )

          ExecutionHandler.send_execution_request(runtime.id, execution_request)

          ServiceResponse.success(message: 'Triggered test execution', payload: execution_identifier)
        rescue GRPC::Unavailable => e
          logger.warn(
            message: 'Failed to push test execution request to gateway',
            runtime_id: runtime.id,
            grpc_details: e.details
          )

          ServiceResponse.error(message: 'Runtime is not connected to the gateway', error_code: :runtime_unavailable)
        end
      end
    end
  end
end
