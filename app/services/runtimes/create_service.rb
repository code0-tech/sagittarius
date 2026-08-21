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

        assign_as_primary_if_only_runtime(runtime)

        ServiceResponse.success(payload: runtime)
      end
    end

    private

    def assign_as_primary_if_only_runtime(runtime)
      return if namespace.nil?
      return unless namespace.runtimes.one?

      namespace.projects.where(primary_runtime_id: nil).find_each do |project|
        project.runtimes << runtime unless project.runtimes.include?(runtime)
        project.update!(primary_runtime: runtime)
      end
    end
  end
end
