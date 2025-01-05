# frozen_string_literal: true

module Users
  module Identity
    class UnlinkService < BaseService
      include Sagittarius::Database::Transactional

      attr_reader :current_authentication, :identity, :args

      def initialize(current_authentication, identity)
        super()
        @current_authentication = current_authentication
        @identity = identity
      end

      def execute
        transactional do |t|
          if identity.nil?
            t.rollback_and_return! ServiceResponse.error(payload: :given_nil_identity,
                                                         message: 'Nil identity given')
          end

          identity.delete

          AuditService.audit(
            :user_identity_unlinked,
            author_id: current_authentication.user.id,
            entity: current_authentication.user,
            details: { provider_id: identity.provider_id, identifier: identity.identifier },
            target: current_authentication.user
          )

          ServiceResponse.success(payload: identity)
        end
      end
    end
  end
end
