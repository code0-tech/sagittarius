# frozen_string_literal: true

module Types
  class RuntimeType < Types::BaseObject
    description 'Represents a runtime'

    authorize :read_runtime

    field :description, String, null: false, description: 'The description for the runtime if present'
    field :modules, Types::RuntimeModuleType.connection_type, null: false, description: 'Modules of the runtime',
                                                              method: :runtime_modules
    field :name, String, null: false, description: 'The name for the runtime'
    field :namespace, Types::NamespaceType, null: true, description: 'The parent namespace for the runtime'
    field :projects, Types::NamespaceProjectType.connection_type, null: false,
                                                                  description: 'Projects associated with the runtime'
    field :status, Types::RuntimeStatusType, null: false, description: 'The status of the runtime',
                                             method: :ensure_runtime_status!
    field :token, String, null: true, description: 'Token belonging to the runtime, only present on creation'

    expose_abilities %i[
      delete_runtime
      update_runtime
      rotate_runtime_token
    ]

    id_field Runtime
    timestamps

    def token
      object.token if object.token_previously_changed?
    end
  end
end
