# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      class TriggerExecutionService
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

          execution_identifier = "SGT-TE-#{current_authentication.user.id}-#{flow.id}-#{SecureRandom.hex}"

          execution_request = Tucana::Sagittarius::TestExecutionRequest.new(
            flow_id: flow.id,
            execution_identifier: execution_identifier,
            body: Tucana::Shared::Value.from_ruby(input)
          )

          ExecutionHandler.send_execution_request(runtime.id, execution_request)

          ServiceResponse.success(message: 'Triggered test execution', payload: execution_identifier)
        end
      end
    end
  end
end
