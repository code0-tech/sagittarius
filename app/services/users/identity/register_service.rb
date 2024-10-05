# frozen_string_literal: true

module Users
  module Identity
    class RegisterService < BaseService
      include Sagittarius::Database::Transactional
      include Sagittarius::Loggable

      attr_reader :provider_id, :args

      def initialize(provider_id, args)
        super()
        @provider_id = provider_id.to_sym
        @args = args
      end

      def execute
        unless ApplicationSetting.current[:user_registration_enabled]
          return ServiceResponse.error(message: 'User registration is disabled', payload: :registration_disabled)
        end

        begin
          identity = identity_provider.load_identity(provider_id, args)
        rescue Code0::Identities::Error => e
          logger.warn(message: 'Identity validation failed', exception: e)
          return ServiceResponse.error(message: e.message, payload: :identity_validation_failed)
        end

        identifier = identity.identifier
        username = identity.username
        email = identity.email
        firstname = identity.firstname
        lastname = identity.lastname
        password = SecureRandom.base58(50)

        return ServiceResponse.error(message: 'No email given', payload: :missing_identity_data) if email.nil?

        username = email.split('@').first if username.nil?

        username = username[0..49] if username.length > 50

        while User.exists?(username: username)
          username += SecureRandom.base36(1)
          username = SecureRandom.base36(20) if username.length > 50
        end

        transactional do |t|
          user = User.create(username: username, email: email, password: password, firstname: firstname,
                             lastname: lastname)
          return ServiceResponse.error(message: 'User is invalid', payload: user.errors) unless user.persisted?

          user_identity = UserIdentity.create(user: user, provider_id: provider_id, identifier: identifier)
          unless user_identity.persisted?
            t.rollback_and_return! ServiceResponse.error(message: 'UserIdentity is invalid',
                                                         payload: user_identity.errors)
          end
          user_session = UserSession.create(user: user)
          unless user_session.persisted?
            t.rollback_and_return! ServiceResponse.error(message: 'UserSession is invalid',
                                                         payload: user_session.errors)
          end

          AuditService.audit(
            :user_registered,
            author_id: user.id,
            entity: user,
            details: {
              provider_id: provider_id,
              identifier: identifier,
            },
            target: user
          )

          ServiceResponse.success(payload: user_session)
        end
      end
    end
  end
end
