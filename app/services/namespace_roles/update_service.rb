# frozen_string_literal: true

module NamespaceRoles
  class UpdateService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :namespace_role, :params

    def initialize(current_user, namespace_role, params)
      @current_user = current_user
      @namespace_role = namespace_role
      @params = params
    end

    def execute
      unless Ability.allowed?(current_user, :update_namespace_role, namespace_role)
        return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
      end

      transactional do |t|
        success = namespace_role.update(params)
        unless success
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to update namespace role',
            payload: namespace_role.errors
          )
        end

        AuditService.audit(
          :namespace_role_updated,
          author_id: current_user.id,
          entity: namespace_role,
          target: namespace_role.namespace,
          details: params
        )

        ServiceResponse.success(message: 'Updated namespace role', payload: namespace_role)
      end
    end
  end
end
