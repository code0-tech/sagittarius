# frozen_string_literal: true

module Users
  class SetActiveSubscriptionService
    include Sagittarius::Database::Transactional

    ACTIVE_SUBSCRIPTION_KEY = 'active_subscription'

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

      active ? set_active_subscription : unset_active_subscription
    end

    private

    def set_active_subscription
      transactional do |t|
        attribute = user.user_custom_attributes.find_or_initialize_by(key: ACTIVE_SUBSCRIPTION_KEY)
        attribute.value = true

        unless attribute.save
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to set active subscription',
            error_code: :invalid_user_custom_attribute,
            details: attribute.errors
          )
        end

        audit(active: true)

        ServiceResponse.success(message: 'Set active subscription', payload: user)
      end
    end

    def unset_active_subscription
      transactional do |_t|
        user.user_custom_attributes.where(key: ACTIVE_SUBSCRIPTION_KEY).destroy_all

        audit(active: false)

        ServiceResponse.success(message: 'Unset active subscription', payload: user)
      end
    end

    def audit(active:)
      AuditService.audit(
        :user_custom_attribute_updated,
        author_id: current_authentication.user.id,
        entity: user,
        target: AuditEvent::GLOBAL_TARGET,
        details: { key: ACTIVE_SUBSCRIPTION_KEY, active: active }
      )
    end
  end
end
