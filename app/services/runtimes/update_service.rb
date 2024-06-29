# frozen_string_literal: true

module Runtimes
  class UpdateService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :runtime, :params

    def initialize(current_user, runtime, params)
      @current_user = current_user
      @runtime = runtime
      @params = params
    end

    def execute
      if runtime.namespace.present?
        unless Ability.allowed?(current_user, :update_runtime, runtime.namespace)
          return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
        end
      else
        unless Ability.allowed?(current_user, :update_runtime)
          return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
        end
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
          author_id: current_user.id,
          entity: runtime,
          target: runtime.namespace || AuditEvent::GLOBAL_TARGET,
          details: params
        )

        ServiceResponse.success(message: 'Updated runtime', payload: runtime)
      end
    end
  end
end
