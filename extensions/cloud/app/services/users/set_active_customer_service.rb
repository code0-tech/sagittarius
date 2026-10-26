# frozen_string_literal: true

module Users
  class SetActiveCustomerService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :user, :active

    def initialize(current_authentication, user, active:)
      @current_authentication = current_authentication
      @user = user
      @active = active
    end

    def execute
      unless Ability.allowed?(current_authentication, :update_user_custom_attribute, user)
        return ServiceResponse.error(message: 'Missing permission', error_code: :missing_permission)
      end

      transactional do |t|
        attribute = user.user_custom_attributes.find_or_initialize_by(key: User::ACTIVE_CUSTOMER_KEY)
        attribute.value = active

        unless attribute.save
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to set active customer status',
            error_code: :invalid_user_custom_attribute,
            details: attribute.errors
          )
        end

        AuditService.audit(
          :user_custom_attribute_updated,
          author_id: current_authentication.user.id,
          entity: user,
          target: AuditEvent::GLOBAL_TARGET,
          details: { key: User::ACTIVE_CUSTOMER_KEY, active: active }
        )

        ServiceResponse.success(message: 'Set active customer status', payload: user)
      end
    end
  end
end
