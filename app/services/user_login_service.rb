# frozen_string_literal: true

class UserLoginService
  include Sagittarius::Loggable

  attr_reader :args

  def initialize(args)
    @args = args
  end

  def execute
    user = User.authenticate_by(args)
    if user.nil?
      logger.info(message: 'Failed login', username: args[:username], email: args[:email])
      return ServiceResponse.error(message: 'Invalid login data', payload: :invalid_login_data)
    end

    user_session = UserSession.create(user: user)
    unless user_session.valid?
      logger.warn(message: 'Failed to create valid session for user', user_id: user.id, username: user.username)
      return ServiceResponse.error(message: 'UserSession is invalid',
                                   payload: user_session.errors)
    end

    logger.info(message: 'Login to user', user_id: user.id, username: user.username)
    ServiceResponse.success(payload: user_session)
  end
end
