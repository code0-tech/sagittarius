module Users
  module Identity
    class LinkService < BaseService
      include Sagittarius::Database::Transactional

      attr_reader :current_user, :provider_id, :args

      def initialize(current_user, provider_id, args)
        @current_user = current_user
        @provider_id = provider_id
        @args = args
      end

      def execute
        begin
          identity = identity_provider.load_identity(provider_id, args)
        rescue Code0::Identities::Error => e
          return ServiceResponse.error(payload: e, message: "An error occurred while loading external identity")
        end
        if identity.nil?
          return ServiceResponse.error(payload: :invalid_external_identity, message: "External identity is nil")
        end

        transactional do |t|
          user_identity = UserIdentity.create(user: current_user, identifier: identity.identifier, provider_id: provider_id)

          unless user_identity.valid?
            t.rollback_and_return! ServiceResponse.error(payload: user_identity.errors, message: "An error occurred while creating user identity")
          end

          current_user.user_identities << user_identity

          unless current_user.save
            t.rollback_and_return! ServiceResponse.error(payload: current_user.errors, message: "Failed to save user")
          end

          AuditService.audit(
            :user_identity_linked,
            author_id: current_user.id,
            entity: current_user,
            details: { provider_id: user_identity.provider_id, identifier: identity.identifier },
            target: current_user
          )

          ServiceResponse.success(payload: current_user)
        end
      end
    end
  end
end
