# frozen_string_literal: true

class UserCreateService
  include Sagittarius::Loggable

  attr_reader :username, :email, :password

  def initialize(username, email, password)
    @username = username
    @email = email
    @password = password
  end

  def execute
    user = User.create(username: username, email: email, password: password)
    return ServiceResponse.error(message: 'User is invalid', payload: user.errors) unless user.valid?

    logger.info(message: 'Created new user', user_id: user.id, username: user.username)
    ServiceResponse.success(payload: user)
  end
end
