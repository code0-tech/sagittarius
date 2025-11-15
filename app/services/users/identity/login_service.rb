# frozen_string_literal: true

module Users
  module Identity
    class LoginService < BaseService
      include Sagittarius::Database::Transactional
      include Code0::ZeroTrack::Loggable

      attr_reader :provider_id, :args

      def initialize(provider_id, args)
        super()
        @provider_id = provider_id
        @args = args
      end

      def execute
        begin
          identity = identity_provider.load_identity(provider_id, args)
        rescue Code0::Identities::Error => e
          logger.warn(message: 'Failed to load external identity', provider_id: provider_id, error: e.message,
                      backtrace: e.backtrace)
          return ServiceResponse.error(error_code: :loading_identity_failed,
                                       message: 'An error occurred while loading external identity')
        end
        if identity.nil?
          return ServiceResponse.error(error_code: :invalid_external_identity, message: 'External identity is nil')
        end

        user_identity = UserIdentity.find_by(provider_id: identity.provider.to_s, identifier: identity.identifier)

        if user_identity.nil?
          return ServiceResponse.error(error_code: :external_identity_does_not_exist,
                                       message: 'No user with that external identity exists, please register first')
        end

        user = user_identity.user

        transactional do |t|
          user_session = UserSession.create(user: user)
          unless user_session.persisted?
            t.rollback_and_return! ServiceResponse.error(message: 'UserSession is invalid',
                                                         error_code: :invalid_user_session,
                                                         details: user_session.errors)
          end

          AuditService.audit(
            :user_logged_in,
            author_id: user.id,
            entity: user,
            details: { provider_id: user_identity.provider_id, identifier: identity.identifier },
            target: user
          )

          ServiceResponse.success(payload: user_session)
        end
      end
    end
  end
end
