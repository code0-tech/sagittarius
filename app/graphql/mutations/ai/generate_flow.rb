# frozen_string_literal: true

module Mutations
  module Ai
    class GenerateFlow < BaseMutation
      description 'Start an AI flow generation job.'

      field :execution_identifier,
            type: GraphQL::Types::String,
            null: true,
            description: 'Identifier that can be used to subscribe to the generated flow response.'

      argument :flow_id,
               type: Types::GlobalIdType[::Flow],
               required: false,
               description: 'Flow to update with the prompt'
      argument :model_identifier,
               type: GraphQL::Types::String,
               required: true,
               description: 'Selected AI model identifier'
      argument :project_id,
               type: Types::GlobalIdType[::NamespaceProject],
               required: true,
               description: 'Project to generate a flow for'
      argument :prompt,
               type: GraphQL::Types::String,
               required: true,
               description: 'Prompt to send to AI'

      def resolve(project_id:, prompt:, model_identifier:, flow_id: nil)
        return error_response(:invalid_setting, 'AI is disabled') unless ai_enabled?

        project = SagittariusSchema.object_from_id(project_id)
        return error_response(:project_not_found, 'Invalid project id') if project.nil?

        flow = flow_id.present? ? SagittariusSchema.object_from_id(flow_id) : nil
        return error_response(:flow_not_found, 'Flow does not exist') if flow_id.present? && flow.nil?
        if flow.present? && flow.project != project
          return error_response(:invalid_flow, 'Flow does not belong to the project')
        end
        return error_response(:no_primary_runtime, 'Project has no primary runtime') if project.primary_runtime.nil?

        return error_response(:missing_permission, 'Missing permission') unless allowed?(project, flow)

        execution_identifier = SecureRandom.uuid
        VelorumGenerateFlowJob.perform_later(execution_identifier, project.id, prompt, model_identifier, flow&.id)

        { execution_identifier: execution_identifier, errors: [] }
      end

      private

      def ai_enabled?
        Sagittarius::Configuration.config[:velorum][:enabled]
      end

      def allowed?(project, flow)
        return false unless Ability.allowed?(current_authentication, :read_velorum_config, :global)

        ability = flow.present? ? :update_flow : :create_flow
        subject = flow || project

        Ability.allowed?(current_authentication, ability, subject)
      end

      def error_response(error_code, message)
        {
          execution_identifier: nil,
          errors: [create_error(error_code, message)],
        }
      end
    end
  end
end
