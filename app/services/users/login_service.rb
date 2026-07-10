# frozen_string_literal: true

module Users
  class LoginService
    include Sagittarius::Database::Transactional
    include Code0::ZeroTrack::Loggable

    attr_reader :args

    def initialize(args)
      @args = args
    end

    def execute
      mfa = args.delete(:mfa)
      user = User.authenticate_by(args)
      if user.nil?
        logger.info(message: 'Failed login', username: args[:username], email: args[:email])
        return ServiceResponse.error(message: 'Invalid login data', error_code: :invalid_login_data)
      end

      transactional do |t|
        if mfa.present? && !user.mfa_enabled?
          t.rollback_and_return! ServiceResponse.error(message: 'Tried to login via MFA even if mfa is disabled',
                                                       error_code: :mfa_failed)
        end

        mfa_passed, mfa_type = user.validate_mfa!(mfa)

        if !mfa_passed && user.mfa_enabled?
          t.rollback_and_return! ServiceResponse.error(message: 'MFA failed',
                                                       error_code: :mfa_failed)
        end

        user_session = UserSession.create(user: user)
        unless user_session.persisted?
          logger.warn(message: 'Failed to create valid session for user', user_id: user.id, username: user.username)
          t.rollback_and_return! ServiceResponse.error(message: 'UserSession is invalid',
                                                       error_code: :invalid_user_session,
                                                       details: user_session.errors)
        end

        AuditService.audit(
          :user_logged_in,
          author_id: user.id,
          entity: user,
          details: args.slice(:username, :email).merge({ method: :username_and_password, mfa_type: mfa_type }),
          target: user
        )

        logger.info(message: 'Login to user', user_id: user.id, username: user.username)
        ServiceResponse.success(payload: user_session)
      end
    end
  end
end
