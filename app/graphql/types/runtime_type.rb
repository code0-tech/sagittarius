# frozen_string_literal: true

module Types
  class RuntimeType < Types::BaseObject
    description 'Represents a runtime'

    authorize :read_runtime

    field :data_types, Types::DataTypeType.connection_type, null: false, description: 'DataTypes of the runtime'
    field :description, String, null: false, description: 'The description for the runtime if present'
    field :name, String, null: false, description: 'The name for the runtime'
    field :namespace, Types::NamespaceType, null: true, description: 'The parent namespace for the runtime'
    field :status, Types::RuntimeStatusType, null: false, description: 'The status of the runtime'
    field :token, String, null: true, description: 'Token belonging to the runtime, only present on creation'

    id_field Runtime
    timestamps

    def token
      object.token if object.token_previously_changed?
    end
  end
end
