# frozen_string_literal: true

module Types
  class RuntimeType < Types::BaseObject
    description 'Represents a runtime'

    authorize :read_runtime

    field :token, String, null: true, description: 'Token belonging to the runtime, only present on creation'
    field :user, Types::NamespaceType, null: false, description: 'Namespace that belongs to the session'

    id_field Runtime
    timestamps

    def token
      object.token if object.id_previously_changed?
    end
  end
end
