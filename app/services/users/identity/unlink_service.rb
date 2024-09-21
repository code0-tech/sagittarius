# frozen_string_literal: true

module Users
  module Identity
    class UnlinkService < BaseService
      include Sagittarius::Database::Transactional

      attr_reader :current_user, :identity, :args

      def initialize(current_user, identity)
        super()
        @current_user = current_user
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
            author_id: current_user.id,
            entity: current_user,
            details: { provider_id: identity.provider_id, identifier: identity.identifier },
            target: current_user
          )

          ServiceResponse.success(payload: identity)
        end
      end
    end
  end
end
