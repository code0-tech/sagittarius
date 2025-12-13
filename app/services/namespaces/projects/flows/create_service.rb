# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      class CreateService
        include Sagittarius::Database::Transactional
        include FlowServiceHelper

        attr_reader :current_authentication, :namespace_project, :flow_input

        def initialize(current_authentication, namespace_project:, flow_input:)
          @current_authentication = current_authentication
          @namespace_project = namespace_project
          @flow_input = flow_input
        end

        def execute
          unless Ability.allowed?(current_authentication, :create_flow, namespace_project)
            return ServiceResponse.error(message: 'Missing permission', error_code: :missing_permission)
          end

          if namespace_project.primary_runtime.nil?
            return ServiceResponse.error(
              message: 'Project has no primary runtime',
              error_code: :no_primary_runtime
            )
          end
          transactional do |t|
            flow_type = FlowType.find_by(id: flow_input.type.model_id, runtime_id: namespace_project.primary_runtime.id)

            if flow_type.nil?
              t.rollback_and_return! ServiceResponse.error(
                message: 'Invalid flow type for the project runtime',
                error_code: :invalid_flow_type
              )
            end

            flow = Flow.new(
              project: namespace_project,
              name: flow_input.name,
              flow_type: flow_type,
              input_type: flow_type.input_type,
              return_type: flow_type.return_type
            )

            UpdateService.new(
              current_authentication,
              flow,
              flow_input
            ).update_flow(t)

            AuditService.audit(
              :flow_created,
              author_id: current_authentication.user.id,
              entity: flow,
              target: namespace_project,
              details: {
                **flow.attributes.except('created_at', 'updated_at'),
              }
            )

            ServiceResponse.success(message: 'Created new flow', payload: flow)
          end
        end
      end
    end
  end
end
