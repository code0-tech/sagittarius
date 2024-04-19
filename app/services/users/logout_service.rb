# frozen_string_literal: true

module Users
  class LogoutService
    include Sagittarius::Loggable

    def initialize(current_user, user_session)
      @current_user = current_user
      @user_session = user_session
    end

    def execute
      unless Ability.allowed?(@current_user, :logout_session, @user_session)
        return ServiceResponse.error(payload: :missing_permission)
      end

      @user_session.active = false

      if @user_session.save
        logger.info(message: 'Logged out session', session_id: @user_session.id, user_id: @user_session.user_id)
        ServiceResponse.success(message: 'Logged out session', payload: @user_session)
      else
        logger.warn(message: 'Failed to log out session', session_id: @user_session.id, user_id: @user_session.user_id)
        ServiceResponse.error(payload: @user_session.errors)
      end
    end
  end
end

