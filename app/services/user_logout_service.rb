# frozen_string_literal: true

class UserLogoutService
  include Sagittarius::Loggable

  def initialize(current_user, user_session)
    @current_user = current_user
    @user_session = user_session
  end

  def execute
    unless Ability.allowed?(@current_user, :logout_session, @user_session)
      return ServiceResponse.error(payload: "You can't log out this session")
    end

    @user_session.active = false

    if @user_session.save
      logger.info(message: 'Logged out session', session_id: @user_session.id, user_id: @user_session.user_id)
      ServiceResponse.success(message: 'Logged out session', payload: @user_session)
    else
      logger.warn(message: 'Failed to log out session', session_id: @user_session.id, user_id: @user_session.user_id)
      ServiceResponse.error(payload: 'Failed to log out session')
    end
  end
end
