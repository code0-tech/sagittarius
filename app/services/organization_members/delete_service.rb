# frozen_string_literal: true

module OrganizationMembers
  class DeleteService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :organization_member, :organization

    def initialize(current_user, organization_member)
      @current_user = current_user
      @organization_member = organization_member
      @organization = organization_member.organization
    end

    def execute
      unless Ability.allowed?(current_user, :delete_member, organization)
        return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
      end

      transactional do |t|
        organization_member.delete

        if organization_member.persisted?
          t.rollback_and_return! ServiceResponse.error(message: 'Failed to delete organization member',
                                                       payload: organization_member.errors)
        end

        unless organization_member.organization.roles
                                  .joins(:abilities, :member_roles)
                                  .exists?(abilities: { ability: :organization_administrator })
          t.rollback_and_return! ServiceResponse.error(
            message: 'Cannot remove last administrator from organization',
            payload: :cannot_remove_last_administrator
          )
        end

        AuditService.audit(
          :organization_member_deleted,
          author_id: current_user.id,
          entity: organization_member,
          details: {},
          target: organization
        )

        ServiceResponse.success(message: 'Organization member deleted', payload: organization_member)
      end
    end
  end
end
