# frozen_string_literal: true

module Users
  class CreateGuestUserService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :email

    def initialize(current_authentication, email:)
      @current_authentication = current_authentication
      @email = email
    end

    def execute
      unless Ability.allowed?(current_authentication, :create_guest_user, :global)
        return ServiceResponse.error(message: 'Missing permissions', error_code: :missing_permission)
      end

      username = generate_username

      transactional do |t|
        user = ::User.create(
          username: username,
          email: email,
          # Guests can't create a session (GlobalPolicy#create_user_session requires `regular?`),
          # so this password only needs to satisfy has_secure_password's presence validation.
          password: SecureRandom.base58(50),
          user_type: :guest
        )
        unless user.persisted?
          t.rollback_and_return! ServiceResponse.error(
            message: 'User is invalid',
            error_code: :invalid_user,
            details: user.errors
          )
        end

        AuditService.audit(
          :guest_user_created,
          author_id: current_authentication.user.id,
          entity: user,
          details: { username: username, email: email },
          target: AuditEvent::GLOBAL_TARGET
        )

        ServiceResponse.success(payload: user)
      end
    end

    private

    def generate_username
      username = email.split('@').first
      username = username[0..49] if username.length > 50

      while User.exists?(username: username)
        username += SecureRandom.base36(1)
        username = SecureRandom.base36(20) if username.length > 50
      end

      username
    end
  end
end
