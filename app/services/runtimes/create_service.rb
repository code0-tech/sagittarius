# frozen_string_literal: true

module Runtimes
  class CreateService
    include Sagittarius::Database::Transactional

    attr_reader :current_authentication, :namespace, :name, :params

    def initialize(current_authentication, namespace, name, **params)
      @current_authentication = current_authentication
      @namespace = namespace
      @name = name
      @params = params
    end

    def execute
      unless Ability.allowed?(current_authentication, :create_runtime, namespace || :global)
        return ServiceResponse.error(message: 'Missing permissions', error_code: :missing_permission)
      end

      transactional do
        runtime = Runtime.create(namespace: namespace, name: name, **params)
        unless runtime.persisted?
          return ServiceResponse.error(message: 'Runtime is invalid', error_code: :invalid_runtime,
                                       details: runtime.errors)
        end

        AuditService.audit(
          :runtime_created,
          author_id: current_authentication.user.id,
          entity: runtime,
          details: { name: name, **params },
          target: namespace || AuditEvent::GLOBAL_TARGET
        )

        ServiceResponse.success(payload: runtime)
      end
    end
  end
end
