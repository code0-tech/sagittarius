# frozen_string_literal: true

module Namespaces
  module Roles
    class DeleteService
      include Sagittarius::Database::Transactional

      attr_reader :current_authentication, :namespace_role

      def initialize(current_authentication, namespace_role)
        @current_authentication = current_authentication
        @namespace_role = namespace_role
      end

      def execute
        unless Ability.allowed?(current_authentication, :delete_namespace_role, namespace_role)
          return ServiceResponse.error(message: 'Missing permissions', error_code: :missing_permission)
        end

        if !namespace_role.namespace.has_owner? &&
           !namespace_role.namespace.roles.where.not(id: namespace_role.id)
                          .joins(:abilities)
                          .exists?(abilities: { ability: :namespace_administrator })
          return ServiceResponse.error(message: 'Cannot delete last administrator role',
                                       error_code: :cannot_delete_last_admin_role)
        end

        transactional do
          namespace_role.delete

          if namespace_role.persisted?
            return ServiceResponse.error(message: 'Failed to delete namespace role',
                                         error_code: :invalid_namespace_role, details: namespace_role.errors)
          end

          AuditService.audit(
            :namespace_role_deleted,
            author_id: current_authentication.user.id,
            entity: namespace_role,
            details: {},
            target: namespace_role.namespace
          )

          ServiceResponse.success(message: 'Namespace role deleted', payload: namespace_role)
        end
      end
    end
  end
end
