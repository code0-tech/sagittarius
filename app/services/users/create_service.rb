# frozen_string_literal: true

module Users
  class CreateService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :params

    def initialize(current_authentication, **params)
      @current_authentication = current_authentication
      @params = params
    end

    def execute
      unless Ability.allowed?(current_authentication, :create_user, :global)
        return ServiceResponse.error(message: 'Missing permissions', error_code: :missing_permission)
      end

      transactional do
        user = User.create(**params)
        unless user.persisted?
          return ServiceResponse.error(message: 'User is invalid', error_code: :invalid_user,
                                       details: user.errors)
        end

        AuditService.audit(
          :user_created,
          author_id: current_authentication.user.id,
          entity: user,
          details: { **params.except(:password) },
          target: AuditEvent::GLOBAL_TARGET
        )

        ServiceResponse.success(payload: user)
      end
    end
  end
end
