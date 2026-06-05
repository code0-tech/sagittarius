# frozen_string_literal: true

module Mutations
  module Namespaces
    module Projects
      module Flows
        class TriggerExecution < BaseMutation
          description 'Triggers a execution on the flow.'

          field :execution_identifier, GraphQL::Types::String,
                null: true,
                description: 'The execution identifier of the triggered execution.'

          argument :flow_id, Types::GlobalIdType[::Flow],
                   required: true,
                   description: 'The id of the flow which will be triggered'

          argument :runtime_id, Types::GlobalIdType[::Runtime],
                   required: true,
                   description: 'The id of the runtime to trigger the execution on'

          argument :input, GraphQL::Types::JSON,
                   required: true,
                   description: 'The input for the execution'

          def resolve(flow_id:, runtime_id:, input:)
            flow = SagittariusSchema.object_from_id(flow_id)

            if flow.nil?
              return { flow: nil,
                       errors: [create_error(:flow_not_found, 'Invalid flow')] }
            end

            runtime = SagittariusSchema.object_from_id(runtime_id)

            if runtime.nil?
              return { flow: nil,
                       errors: [create_error(:runtime_not_found, 'Invalid runtime')] }
            end

            ::Namespaces::Projects::Flows::TriggerExecutionService.new(
              current_authentication,
              flow: flow,
              runtime: runtime,
              input: input
            ).execute.to_mutation_response(success_key: :execution_identifier)
          end
        end
      end
    end
  end
end
