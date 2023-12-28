# frozen_string_literal: true

class UserRegisterService
  include Sagittarius::Database::Transactional
  include Sagittarius::Loggable

  attr_reader :username, :email, :password

  def initialize(username, email, password)
    @username = username
    @email = email
    @password = password
  end

  def execute
    transactional do
      user = User.create(username: username, email: email, password: password)
      return ServiceResponse.error(message: 'User is invalid', payload: user.errors) unless user.persisted?

      AuditService.audit(
        :user_registered,
        author_id: user.id,
        entity: user,
        details: { username: username, email: email },
        target: user
      )

      logger.info(message: 'Created new user', user_id: user.id, username: user.username)
      ServiceResponse.success(payload: user)
    end
  end
end
