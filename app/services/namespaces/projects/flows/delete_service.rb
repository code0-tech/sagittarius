# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      class CreateService
        include Sagittarius::Database::Transactional

        attr_reader :current_authentication, :flow

        def initialize(current_authentication, flow:)
          @current_authentication = current_authentication
          @flow = flow
        end

        def execute
          unless Ability.allowed?(current_authentication, :delete_flows, namespace_project)
            return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
          end

          transactional do |t|
            flow = flow.delete
            if flow.persisted?
              t.rollback_and_return! ServiceResponse.error(
                message: 'Failed to delete flow',
                payload: flow.errors
              )
            end

            AuditService.audit(
              :flow_deleted,
              author_id: current_authentication.user.id,
              entity: namespace_project,
              target: flow,
              details: {
                **flow.attributes
              }
            )

            ServiceResponse.success(message: 'Created new project', payload: flow)
          end
        end
      end
    end
  end
end
