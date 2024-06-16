# frozen_string_literal: true

module NamespaceRoles
  class CreateService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :namespace, :params

    def initialize(current_user, namespace, params)
      @current_user = current_user
      @namespace = namespace
      @params = params
    end

    def execute
      unless Ability.allowed?(current_user, :create_namespace_role, namespace)
        return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
      end

      transactional do
        namespace_role = NamespaceRole.create(namespace: namespace, **params)

        unless namespace_role.persisted?
          return ServiceResponse.error(message: 'Failed to save namespace role', payload: namespace_role.errors)
        end

        AuditService.audit(
          :namespace_role_created,
          author_id: current_user.id,
          entity: namespace_role,
          details: { name: params[:name] },
          target: namespace
        )

        ServiceResponse.success(message: 'Namespace role created', payload: namespace_role)
      end
    end
  end
end
