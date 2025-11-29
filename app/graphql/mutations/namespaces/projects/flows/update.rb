# frozen_string_literal: true

module Mutations
  module Namespaces
    module Projects
      module Flows
        class Update < BaseMutation
          description 'Update an existing flow.'

          field :flow, Types::FlowType, null: true, description: 'The updated flow.'

          argument :flow_id, Types::GlobalIdType[Flow],
                   required: true, description: 'The ID of the flow to update'

          argument :flow_input, Types::Input::FlowInputType, description: 'The updated flow', required: true

          def resolve(flow_id:, flow_input:, **_params)
            flow = SagittariusSchema.object_from_id(flow_id)

            return { errors: [create_error(:flow_not_found, 'Flow does not exist')] } if flow.nil?

            flow_type = SagittariusSchema.object_from_id(flow_input.type)
            return { errors: [create_error(:flow_type_not_found, 'Invalid flow type id')] } if flow_type.nil?

            ::Namespaces::Projects::Flows::UpdateService.new(
              current_authentication,
              flow,
              flow_input
            ).execute.to_mutation_response(success_key: :flow)
          end
        end
      end
    end
  end
end
