# frozen_string_literal: true

module Users
  class UpdateService
    include Sagittarius::Database::Transactional

    REQUIRES_MFA_FIELDS = %i[
      email
      password
    ].freeze

    attr_reader :current_authentication, :user, :mfa, :params

    def initialize(current_authentication, user, mfa, params)
      @current_authentication = current_authentication
      @user = user
      @mfa = mfa
      @params = params
    end

    def execute
      unless Ability.allowed?(current_authentication, :update_user, user)
        return ServiceResponse.error(message: 'Missing permission', payload: :missing_permission)
      end

      if params.key?(:admin)
        unless current_authentication.user.admin?
          return ServiceResponse.error(message: 'Cannot modify users admin status because user isn`t admin',
                                       payload: :unmodifiable_field)
        end

        if current_authentication.user == user
          return ServiceResponse.error(message: 'Cannot modify own admin status', payload: :unmodifiable_field)
        end
      end

      transactional do |t|
        mfa_type = nil
        if params.keys.intersect?(REQUIRES_MFA_FIELDS) && user.mfa_enabled? # is "critical" field
          if mfa.nil?
            return ServiceResponse.error(
              message: "MFA required for fields: #{params.keys.intersection(REQUIRES_MFA_FIELDS)}",
              payload: :mfa_required
            )
          end

          mfa_passed, mfa_type = user.validate_mfa!(mfa)

          unless mfa_passed
            t.rollback_and_return! ServiceResponse.error(message: 'MFA failed',
                                                         payload: :mfa_failed)
          end
        end

        success = user.update(params)
        unless success
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to update user',
            payload: user.errors
          )
        end

        AuditService.audit(
          :user_updated,
          author_id: current_authentication.user.id,
          entity: user,
          target: user,
          details: params.merge({ mfa_type: mfa_type }.compact).except(:password)
        )

        ServiceResponse.success(message: 'Updated user', payload: user)
      end
    end
  end
end
