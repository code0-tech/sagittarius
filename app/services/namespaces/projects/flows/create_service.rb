# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      class CreateService
        include Sagittarius::Database::Transactional

        attr_reader :current_authentication, :namespace_project, :params

        def initialize(current_authentication, namespace_project:, **params)
          @current_authentication = current_authentication
          @namespace_project = namespace_project
          @params = params
        end

        def execute
          unless Ability.allowed?(current_authentication, :create_flows, namespace_project)
            return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
          end

          transactional do |t|
            flow = Flow.create(project: namespace_project, **params)
            unless flow.persisted?
              t.rollback_and_return! ServiceResponse.error(
                message: 'Failed to create flow',
                payload: flow.errors
              )
            end

            res = ValidationService.new(current_authentication, flow).execute

            if res.error?
              t.rollback_and_return! ServiceResponse.error(
                message: 'Flow validation failed',
                payload: res.payload
              )
            end

            AuditService.audit(
              :flow_created,
              author_id: current_authentication.user.id,
              entity: flow,
              target: namespace_project,
              details: {
                **flow.attributes.except('created_at', 'updated_at'),
              }
            )

            ServiceResponse.success(message: 'Created new project', payload: flow)
          end
        end
      end
    end
  end
end
