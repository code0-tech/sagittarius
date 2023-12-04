# frozen_string_literal: true

class UserCreateService
  attr_reader :username, :email, :password

  def initialize(username, email, password)
    @username = username
    @email = email
    @password = password
  end

  def execute
    user = User.create(username: username, email: email, password: password)
    return ServiceResponse.error(message: 'User is invalid', payload: user.errors) unless user.valid?

    ServiceResponse.success(payload: user)
  end
end
