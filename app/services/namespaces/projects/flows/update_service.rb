# frozen_string_literal: true

module Namespaces
  module Projects
    module Flows
      class UpdateService
        include Sagittarius::Database::Transactional

        attr_reader :current_authentication, :flow, :params

        def initialize(current_authentication, flow:, **params)
          @current_authentication = current_authentication
          @flow = flow
          @params = params
        end

        def execute
          unless Ability.allowed?(current_authentication, :update_flows, flow.project)
            return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
          end

          transactional do |t|
            old_flow_attributes = flow.attributes.except('created_at', 'updated_at')

            success = flow.update(params)

            unless success
              t.rollback_and_return! ServiceResponse.error(
                message: 'Failed to update flow',
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
              entity: flow,
              target: flow.project,
              details: {
                new_flow: flow.attributes.except('created_at', 'updated_at'),
                old_flow: old_flow_attributes,
              }
            )

            ServiceResponse.success(message: 'Created new project', payload: flow)
          end
        end
      end
    end
  end
end
