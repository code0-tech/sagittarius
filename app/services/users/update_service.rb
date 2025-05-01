# frozen_string_literal: true

module Users
  class UpdateService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :user, :params

    def initialize(current_authentication, user, params)
      @current_authentication = current_authentication
      @user = user
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
          details: params.except(:password)
        )

        ServiceResponse.success(message: 'Updated user', payload: user)
      end
    end
  end
end
