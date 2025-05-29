# frozen_string_literal: true

module Mutations
  module Namespaces
    module Projects
      module Flows
        class Create < BaseMutation
          description 'Creates a new flow.'

          field :flow, Types::FlowType, null: true, description: 'The newly created flow.'

          argument :project_id, Types::GlobalIdType[NamespaceProject], required: true,
                   description: 'The ID of the project to which the flow belongs to'

          argument :flow, Types::Input::FlowInputType

          def resolve(project_id:, flow:, **params)
            project = SagittariusSchema.object_from_id(project_id)

            if project.nil?
              return error('Invalid project id')
            end

            input_type = SagittariusSchema.object_from_id(flow.input_type)

            if input_type.nil?
              return error('Invalid input type id')
            end

            return_type = SagittariusSchema.object_from_id(flow.return_type)
            if return_type.nil?
              return error('Invalid return type id')
            end

            flow_type = SagittariusSchema.object_from_id(flow.flow_type)
            if flow_type.nil?
              return error('Invalid flow type id')
            end

            Namespaces::Projects::Flows::CreateService.new(
              create_authentication(context[:current_user]),
              namespace_project: project,
              params: {
                return_type: return_type,
                input_type: input_type,
                flow_type: flow_type,
                starting_node: params[:starting_node],
                settings: params[:settings] || [],
              }
            ).execute.to_mutation_response(success_key: :flow);
          end

          def error(message)
            {
              flow: nil,
              errors: [create_message_error(message)]
            }
          end
        end
      end
    end
  end
end
