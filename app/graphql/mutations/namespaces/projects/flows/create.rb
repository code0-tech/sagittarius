# frozen_string_literal: true

module Mutations
  module Namespaces
    module Projects
      module Flows
        class Create < BaseMutation
          description 'Creates a new flow.'

          field :flow, Types::FlowType, null: true, description: 'The newly created flow.'

          argument :project_id, Types::GlobalIdType[NamespaceProject],
                   required: true, description: 'The ID of the project to which the flow belongs to'

          argument :flow, Types::Input::FlowInputType, description: 'The flow to create', required: true

          def resolve(project_id:, flow:, **_params)
            project = SagittariusSchema.object_from_id(project_id)

            return error('Invalid project id') if project.nil?

            flow_type = SagittariusSchema.object_from_id(flow.type)
            return error('Invalid flow type id') if flow_type.nil?

            ::Namespaces::Projects::Flows::CreateService.new(
              current_authentication,
              namespace_project: project,
              flow_type: flow_type,
              starting_node: flow.starting_node,
              flow_settings: flow.settings || []
            ).execute.to_mutation_response(success_key: :flow)
          end

          def error(message)
            {
              flow: nil,
              errors: [create_message_error(message)],
            }
          end
        end
      end
    end
  end
end
