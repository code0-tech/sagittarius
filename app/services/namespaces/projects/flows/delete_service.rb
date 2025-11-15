# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      class DeleteService
        include Sagittarius::Database::Transactional

        attr_reader :current_authentication, :flow

        def initialize(current_authentication, flow:)
          @current_authentication = current_authentication
          @flow = flow
        end

        def execute
          unless Ability.allowed?(current_authentication, :delete_flow, flow)
            return ServiceResponse.error(message: 'Missing permission', error_code: :missing_permission)
          end

          transactional do |t|
            flow.delete

            if flow.persisted?
              t.rollback_and_return! ServiceResponse.error(
                message: 'Failed to delete flow',
                error_code: :invalid_flow,
                details: flow.errors
              )
            end

            UpdateRuntimesForProjectJob.perform_later(flow.project.id)

            AuditService.audit(
              :flow_deleted,
              author_id: current_authentication.user.id,
              entity: flow,
              target: flow.project,
              details: {
                **flow.attributes.except('created_at', 'updated_at'),
              }
            )

            ServiceResponse.success(message: 'Deleted flow', payload: flow)
          end
        end
      end
    end
  end
end
