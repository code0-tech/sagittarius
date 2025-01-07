# frozen_string_literal: true

module Runtimes
  class UpdateService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :runtime, :params

    def initialize(current_authentication, runtime, params)
      @current_authentication = current_authentication
      @runtime = runtime
      @params = params
    end

    def execute
      unless Ability.allowed?(current_authentication, :update_runtime, runtime.namespace || :global)
        return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
      end

      transactional do |t|
        success = runtime.update(params)
        unless success
          t.rollback_and_return! ServiceResponse.error(
            message: 'Failed to update runtime',
            payload: runtime.errors
          )
        end

        AuditService.audit(
          :runtime_updated,
          author_id: current_authentication.user.id,
          entity: runtime,
          target: runtime.namespace || AuditEvent::GLOBAL_TARGET,
          details: params
        )

        ServiceResponse.success(message: 'Updated runtime', payload: runtime)
      end
    end
  end
end
