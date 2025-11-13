# frozen_string_literal: true

module Users
  class LogoutService
    include Code0::ZeroTrack::Loggable

    attr_reader :current_authentication, :user_session

    def initialize(current_authentication, user_session)
      @current_authentication = current_authentication
      @user_session = user_session
    end

    def execute
      unless Ability.allowed?(current_authentication, :logout_session, user_session)
        return ServiceResponse.error(error_code: :missing_permission)
      end

      user_session.active = false

      if user_session.save
        logger.info(message: 'Logged out session', session_id: user_session.id, user_id: user_session.user_id)
        ServiceResponse.success(message: 'Logged out session', payload: user_session)
      else
        logger.warn(message: 'Failed to log out session', session_id: user_session.id, user_id: user_session.user_id)
        ServiceResponse.error(error_code: user_session.errors)
      end
    end
  end
end
