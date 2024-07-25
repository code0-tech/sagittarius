# frozen_string_literal: true

module Runtimes
  class RotateTokenService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :runtime

    def initialize(current_user, runtime)
      @current_user = current_user
      @runtime = runtime
    end

    def execute
      unless Ability.allowed?(current_user, :rotate_runtime_token, runtime.namespace || :global)
        return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
      end

      transactional do |t|
        runtime.regenerate_token!
        unless runtime.save
          t.rollback_and_return! ServiceResponse.error(message: 'Failed to rotate runtime token',
                                                       payload: runtime.errors)
        end
        AuditService.audit(
          :runtime_token_rotated,
          author_id: current_user.id,
          entity: runtime,
          details: {},
          target: runtime.namespace || AuditEvent::GLOBAL_TARGET
        )

        ServiceResponse.success(message: 'Runtime token rotated', payload: runtime)
      end
    end
  end
end
