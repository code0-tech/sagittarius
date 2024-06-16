# frozen_string_literal: true

module NamespaceMembers
  class DeleteService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :namespace_member

    def initialize(current_user, namespace_member)
      @current_user = current_user
      @namespace_member = namespace_member
    end

    def execute
      unless Ability.allowed?(current_user, :delete_member, namespace_member)
        return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
      end

      transactional do |t|
        namespace_member.delete

        if namespace_member.persisted?
          t.rollback_and_return! ServiceResponse.error(message: 'Failed to delete namespace member',
                                                       payload: namespace_member.errors)
        end

        unless namespace_member.namespace.roles
                               .joins(:abilities, :member_roles)
                               .exists?(abilities: { ability: :namespace_administrator })
          t.rollback_and_return! ServiceResponse.error(
            message: 'Cannot remove last administrator from namespace',
            payload: :cannot_remove_last_administrator
          )
        end

        AuditService.audit(
          :namespace_member_deleted,
          author_id: current_user.id,
          entity: namespace_member,
          details: {},
          target: namespace_member.namespace
        )

        ServiceResponse.success(message: 'Namespace member deleted', payload: namespace_member)
      end
    end
  end
end
