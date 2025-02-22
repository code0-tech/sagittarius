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
        return ServiceResponse.error(message: 'Invalid login data', payload: :invalid_login_data)
      end

      transactional do |t|
        if mfa.present? && !user.mfa_enabled?
          t.rollback_and_return! ServiceResponse.error(message: 'Tried to login via MFA even if mfa is disabled',
                                                       payload: :mfa_failed)
        end

        mfa_passed, mfa_type = validate_mfa(mfa, t, user)

        if !mfa_passed && user.mfa_enabled?
          t.rollback_and_return! ServiceResponse.error(message: 'MFA failed',
                                                       payload: :mfa_failed)
        end

        user_session = UserSession.create(user: user)
        unless user_session.persisted?
          logger.warn(message: 'Failed to create valid session for user', user_id: user.id, username: user.username)
          t.rollback_and_return! ServiceResponse.error(message: 'UserSession is invalid',
                                                       payload: user_session.errors)
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

    private

    def validate_mfa(mfa, t, user)
      mfa_passed = false
      mfa_type = mfa&.[](:type)
      mfa_value = mfa&.[](:value)

      case mfa_type
      when :backup_code
        backup_code = BackupCode.where(user: user, token: mfa_value)
        mfa_passed = backup_code.count.positive?
        backup_code.delete_all
        unless backup_code.count.zero?
          t.rollback_and_return! ServiceResponse.error(message: 'Failed to invalidate used backup code',
                                                       payload: :mfa_failed)
        end
      when :totp
        totp = ROTP::TOTP.new(user.totp_secret)
        mfa_passed = totp.verify(mfa_value)
      end
      [mfa_passed, mfa_type]
    end
  end
end
