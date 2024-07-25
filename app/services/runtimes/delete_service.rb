# frozen_string_literal: true

module Runtimes
  class DeleteService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :runtime

    def initialize(current_user, runtime)
      @current_user = current_user
      @runtime = runtime
    end

    def execute
      unless Ability.allowed?(current_user, :delete_runtime, runtime.namespace || :global)
        return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
      end

      transactional do |t|
        runtime.delete

        if runtime.persisted?
          t.rollback_and_return! ServiceResponse.error(message: 'Failed to delete organization',
                                                       payload: runtime.errors)
        end

        AuditService.audit(
          :runtime_deleted,
          author_id: current_user.id,
          entity: runtime,
          details: {},
          target: runtime.namespace || AuditEvent::GLOBAL_TARGET
        )

        ServiceResponse.success(message: 'Runtime deleted', payload: runtime)
      end
    end
  end
end
