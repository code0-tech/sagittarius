# frozen_string_literal: true

class UserLoginService
  attr_reader :args

  def initialize(args)
    @args = args
  end

  def execute
    user = User.authenticate_by(args)
    return ServiceResponse.error(message: 'Invalid login data', payload: ['Invalid login data']) if user.nil?

    user_session = UserSession.create(user: user)
    unless user_session.valid?
      return ServiceResponse.error(message: 'UserSession is invalid',
                                   payload: user_session.errors)
    end

    ServiceResponse.success(payload: user_session)
  end
end
