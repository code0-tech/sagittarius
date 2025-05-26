# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      class CreateService
        include Sagittarius::Database::Transactional

        attr_reader :current_authentication, :old_flow, :new_flow

        def initialize(current_authentication, old_flow:, new_flow:)
          @current_authentication = current_authentication
          @old_flow = old_flow
          @new_flow = new_flow
        end

        def execute
          unless Ability.allowed?(current_authentication, :delete_flows, namespace_project)
            return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
          end

          transactional do |t|
            flow.update(new_flow.attributes.except('id', 'created_at', 'updated_at'))
            if flow.persisted?
              t.rollback_and_return! ServiceResponse.error(
                message: 'Failed to delete flow',
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
              :flow_updated,
              author_id: current_authentication.user.id,
              entity: namespace_project,
              target: flow,
              details: {
                old_flow: old_flow.attributes,
                new_flow: new_flow.attributes
              }
            )

            ServiceResponse.success(message: 'Created new project', payload: flow)
          end
        end
      end
    end
  end
end
