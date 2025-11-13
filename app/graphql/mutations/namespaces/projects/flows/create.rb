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

            if project.nil?
              return {
                flow: nil,
                errors: [create_error(:namespace_project_not_found, 'Invalid project id')],
              }
            end

            flow_type = SagittariusSchema.object_from_id(flow.type)
            if flow_type.nil?
              return {
                flow: nil,
                errors: [create_error(:flow_type_not_found, 'Invalid flow type id')],
              }
            end

            ::Namespaces::Projects::Flows::CreateService.new(
              current_authentication,
              namespace_project: project,
              flow_type: flow_type,
              starting_node: flow.starting_node,
              flow_settings: flow.settings || [],
              name: flow.name
            ).execute.to_mutation_response(success_key: :flow)
          end
        end
      end
    end
  end
end
