# frozen_string_literal: true

module Runtimes
  class DeleteService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :runtime

    def initialize(current_authentication, runtime)
      @current_authentication = current_authentication
      @runtime = runtime
    end

    def execute
      unless Ability.allowed?(current_authentication, :delete_runtime, runtime.namespace || :global)
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
          author_id: current_authentication.user.id,
          entity: runtime,
          details: {},
          target: runtime.namespace || AuditEvent::GLOBAL_TARGET
        )

        ServiceResponse.success(message: 'Runtime deleted', payload: runtime)
      end
    end
  end
end
