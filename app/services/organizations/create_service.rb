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

        organization_role = create_org_role(organization, t)
        create_role_ability(organization_role, t)
        organization_member = create_org_member(organization, t)
        create_org_member_role(organization_member, organization_role, t)

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

    def create_org_member_role(organization_member, organization_role, t)
      organization_member_role = OrganizationMemberRole.create(member: organization_member, role: organization_role)
      return if organization_member_role.persisted?

      t.rollback_and_return! ServiceResponse.error(message: 'Failed to create organization member role',
                                                   payload: organization_member_role.errors)
    end

    def create_org_member(organization, t)
      organization_member = OrganizationMember.create(organization: organization, user: current_user)
      unless organization_member.persisted?
        t.rollback_and_return! ServiceResponse.error(message: 'Failed to create organization member',
                                                     payload: organization_member.errors)
      end
      organization_member
    end

    def create_role_ability(organization_role, t)
      organization_role_ability = OrganizationRoleAbility.create(organization_role: organization_role,
                                                                 ability: :assign_role_abilities)
      return if organization_role_ability.persisted?

      t.rollback_and_return! ServiceResponse.error(message: 'Failed to create organization ability',
                                                   payload: organization_role_ability.errors)
    end

    def create_org_role(organization, t)
      organization_role = OrganizationRole.create(organization: organization, name: 'Admin')
      unless organization_role.persisted?
        t.rollback_and_return! ServiceResponse.error(message: 'Failed to create organization role',
                                                     payload: organization_role.errors)
      end
      organization_role
    end
  end
end
