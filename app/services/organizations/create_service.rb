# frozen_string_literal: true

module Organizations
  class CreateService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :name

    def initialize(current_user, name:)
      @current_user = current_user
      @name = name
    end

    def execute
      unless Ability.allowed?(current_user, :create_organization)
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

        organization_role = create_object(t, OrganizationRole, organization: organization, name: 'Administrator')
        create_object(t, OrganizationRoleAbility, organization_role: organization_role, ability: :organization_administrator)
        organization_member = create_object(t, OrganizationMember, organization: organization, user: current_user)
        create_object(t, OrganizationMemberRole, member: organization_member, role: organization_role)

        AuditService.audit(
          :organization_created,
          author_id: current_user.id,
          entity: organization,
          target: organization,
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
