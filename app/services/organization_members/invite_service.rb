# frozen_string_literal: true

module OrganizationMembers
  class InviteService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :organization, :user

    def initialize(current_user, organization, user)
      @current_user = current_user
      @organization = organization
      @user = user
    end

    def execute
      unless Ability.allowed?(current_user, :invite_member, organization)
        return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
      end

      transactional do |t|
        organization_member = OrganizationMember.create(organization: organization, user: user)

        unless organization_member.persisted?
          t.rollback_and_return! ServiceResponse.error(message: 'Failed to save organization member',
                                                       payload: organization_member.errors)
        end

        AuditService.audit(
          :organization_member_invited,
          author_id: current_user.id,
          entity: organization_member,
          details: {},
          target: organization
        )

        ServiceResponse.success(message: 'Organization member invited', payload: organization_member)
      end
    end
  end
end
