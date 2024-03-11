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

        organization_member = OrganizationMember.create(organization: organization, user: current_user)
        unless organization_member.persisted?
          t.rollback_and_return! ServiceResponse.error(message: 'Failed to create organization member',
                                                       payload: organization_member.errors)
        end

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
  end
end
