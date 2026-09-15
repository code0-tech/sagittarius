# frozen_string_literal: true

module Users
  class CompleteGuestProfileService
    include Sagittarius::Database::Transactional

    attr_reader :claim_token, :username, :password, :firstname, :lastname

    def initialize(claim_token, username:, password:, firstname: nil, lastname: nil)
      @claim_token = claim_token
      @username = username
      @password = password
      @firstname = firstname
      @lastname = lastname
    end

    def execute
      user = ::User.find_by_token_for(:guest_claim, claim_token)

      if user.nil? || !user.guest?
        return ServiceResponse.error(message: 'Invalid or expired claim token',
                                     error_code: :invalid_verification_code)
      end

      transactional do |t|
        user.assign_attributes(
          username: username,
          password: password,
          firstname: firstname,
          lastname: lastname,
          user_type: :regular,
          email_verified_at: Time.zone.now
        )
        unless user.save
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to complete guest profile',
            error_code: :invalid_user,
            details: user.errors
          )
        end

        user_session = UserSession.create(user: user)
        unless user_session.persisted?
          t.rollback_and_return! ServiceResponse.error(
            message: 'UserSession is invalid',
            error_code: :invalid_user_session,
            details: user_session.errors
          )
        end

        AuditService.audit(
          :guest_profile_completed,
          author_id: user.id,
          entity: user,
          target: user,
          details: { username: username }
        )

        ServiceResponse.success(payload: user_session)
      end
    end
  end
end
