# frozen_string_literal: true

module Users
  class LoginService
    include Sagittarius::Database::Transactional
    include Sagittarius::Loggable

    attr_reader :args

    def initialize(args)
      @args = args
    end

    def execute
      mfa = args.delete(:mfa)
      user = User.authenticate_by(args)
      if user.nil?
        logger.info(message: 'Failed login', username: args[:username], email: args[:email])
        return ServiceResponse.error(message: 'Invalid login data', payload: :invalid_login_data)
      end

      # validate mfa

      mfa_passed = false
      mfa_type = mfa&.[](:type)
      mfa_value = mfa&.[](:value)

      case mfa_type
      when 'totp'
        totp = ROTP::TOTP.new(user.totp_secret)
        mfa_passed = totp.verify(mfa_value)
      end

      return ServiceResponse.error(message: 'MFA failed', payload: :mfa_failed) if !mfa_passed && user.mfa_enabled?

      transactional do
        user_session = UserSession.create(user: user)
        unless user_session.persisted?
          logger.warn(message: 'Failed to create valid session for user', user_id: user.id, username: user.username)
          return ServiceResponse.error(message: 'UserSession is invalid',
                                       payload: user_session.errors)
        end

        AuditService.audit(
          :user_logged_in,
          author_id: user.id,
          entity: user,
          details: args.slice(:username, :email).merge({ method: :username_and_password }),
          target: user
        )

        logger.info(message: 'Login to user', user_id: user.id, username: user.username)
        ServiceResponse.success(payload: user_session)
      end
    end
  end
end
