# frozen_string_literal: true

module Organizations
  class CreateService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :name

    def initialize(current_authentication, name:)
      @current_authentication = current_authentication
      @name = name
    end

    def execute
      unless Ability.allowed?(current_authentication, :create_organization)
        return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
      end

      transactional do |t|
        organization = Organization.create(name: name)
        unless organization.persisted?
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to create organization',
            payload: organization.errors
          )
        end

        namespace_role = create_object(t, NamespaceRole, namespace: organization.ensure_namespace,
                                                         name: 'Administrator')
        create_object(t, NamespaceRoleAbility, namespace_role: namespace_role, ability: :namespace_administrator)
        organization_member = create_object(t, NamespaceMember, namespace: organization.ensure_namespace,
                                                                user: current_authentication.user)
        create_object(t, NamespaceMemberRole, member: organization_member, role: namespace_role)

        AuditService.audit(
          :organization_created,
          author_id: current_authentication.user.id,
          entity: organization,
          target: organization.ensure_namespace,
          details: { name: name }
        )

        ServiceResponse.success(message: 'Created new organization', payload: organization)
      end
    end

    private

    def create_object(t, model, **params)
      created_object = model.create(params)

      unless created_object.persisted?
        t.rollback_and_return! ServiceResponse.error(message: "Failed to create #{model}",
                                                     payload: created_object.errors)
      end

      created_object
    end
  end
end
