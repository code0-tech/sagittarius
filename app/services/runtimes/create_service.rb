# frozen_string_literal: true

module Runtimes
  class CreateService
    include Sagittarius::Database::Transactional

    attr_reader :current_user, :namespace, :name, :params

    def initialize(current_user, namespace, name, **params)
      @current_user = current_user
      @namespace = namespace
      @name = name
      @params = params
    end

    def execute
      unless Ability.allowed?(current_user, :create_runtime, namespace || :global)
        return ServiceResponse.error(message: 'Missing permissions', payload: :missing_permission)
      end

      transactional do
        runtime = Runtime.create(namespace: namespace, name: name, **params)
        return ServiceResponse.error(message: 'Runtime is invalid', payload: runtime.errors) unless runtime.persisted?

        AuditService.audit(
          :runtime_created,
          author_id: current_user.id,
          entity: runtime,
          details: { name: name, **params },
          target: namespace || AuditEvent::GLOBAL_TARGET
        )

        ServiceResponse.success(payload: runtime)
      end
    end
  end
end
