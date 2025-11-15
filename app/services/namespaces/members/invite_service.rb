# frozen_string_literal: true

module Namespaces
  module Members
    class InviteService
      include Sagittarius::Database::Transactional

      attr_reader :current_authentication, :namespace, :user

      def initialize(current_authentication, namespace, user)
        @current_authentication = current_authentication
        @namespace = namespace
        @user = user
      end

      def execute
        unless Ability.allowed?(current_authentication, :invite_member, namespace)
          return ServiceResponse.error(message: 'Missing permissions', error_code: :missing_permission)
        end

        transactional do |t|
          namespace_member = NamespaceMember.create(namespace: namespace, user: user)

          validate_user_limit!(t)

          unless namespace_member.persisted?
            t.rollback_and_return! ServiceResponse.error(message: 'Failed to save namespace member',
                                                         error_code: :invalid_namespace_member,
                                                         details: namespace_member.errors)
          end

          AuditService.audit(
            :namespace_member_invited,
            author_id: current_authentication.user.id,
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
end

Namespaces::Members::InviteService.prepend_extensions
