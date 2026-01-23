# frozen_string_literal: true

module Types
  class RuntimeType < Types::BaseObject
    description 'Represents a runtime'

    authorize :read_runtime

    field :data_types, Types::DataTypeType.connection_type, null: false, description: 'DataTypes of the runtime'
    field :description, String, null: false, description: 'The description for the runtime if present'
    field :flow_types, Types::FlowTypeType.connection_type, null: false, description: 'FlowTypes of the runtime'
    field :function_definitions, Types::FunctionDefinitionType.connection_type,
          null: false,
          description: 'Function definitions of the runtime'
    field :name, String, null: false, description: 'The name for the runtime'
    field :namespace, Types::NamespaceType, null: true, description: 'The parent namespace for the runtime'
    field :projects, Types::NamespaceProjectType.connection_type, null: false,
                                                                  description: 'Projects associated with the runtime'
    field :status, Types::RuntimeStatusType, null: false, description: 'The status of the runtime'

    field :statuses, Types::RuntimeStatusType.connection_type, null: false,
                                                               description: 'Statuses of the runtime',
                                                               method: :runtime_statuses
    field :token, String, null: true, description: 'Token belonging to the runtime, only present on creation'

    expose_abilities %i[
      delete_runtime
      update_runtime
      rotate_runtime_token
    ]

    id_field Runtime
    timestamps

    # If the last heartbeat was within the last 10 minutes, consider the runtime as 'running'
    def status
      last_heartbeat = object.last_heartbeat

      if last_heartbeat && last_heartbeat >= 10.minutes.ago
        :connected
      else
        :disconnected
      end
    end

    def token
      object.token if object.token_previously_changed?
    end
  end
end
