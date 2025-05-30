# frozen_string_literal: true

module Mutations
  module Namespaces
    module Projects
      module Flows
        class Delete < BaseMutation
          description 'Deletes a namespace project.'

          field :flow, Types::FlowType, null: true, description: 'The deleted flow.'

          argument :flow_id, Types::GlobalIdType[::Flow],
                   description: 'The id of the flow which will be deleted'

          def resolve(flow_id:)
            flow = SagittariusSchema.object_from_id(flow_id)

            if flow.nil?
              return { flow: nil,
                       errors: [create_message_error('Invalid flow')] }
            end

            ::Namespaces::Projects::Flows::DeleteService.new(
              current_authentication,
              flow
            ).execute.to_mutation_response(success_key: :flow)
          end
        end
      end
    end
  end
end
