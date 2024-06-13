# frozen_string_literal: true

module NamespaceMembers
  class InviteService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :namespace, :user

    def initialize(current_user, namespace, user)
      @current_user = current_user
      @namespace = namespace
      @user = user
    end

    def execute
      unless Ability.allowed?(current_user, :invite_member, namespace)
        return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
      end

      transactional do |t|
        namespace_member = NamespaceMember.create(namespace: namespace, user: user)

        validate_user_limit!(t)

        unless namespace_member.persisted?
          t.rollback_and_return! ServiceResponse.error(message: 'Failed to save namespace member',
                                                       payload: namespace_member.errors)
        end

        AuditService.audit(
          :namespace_member_invited,
          author_id: current_user.id,
          entity: namespace_member,
          details: {},
          target: namespace
        )

        ServiceResponse.success(message: 'Namespace member invited', payload: namespace_member)
      end
    end

    protected

    def validate_user_limit!(*)
      # overridden in EE
    end
  end
end

NamespaceMembers::InviteService.prepend_extensions
