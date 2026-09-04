# frozen_string_literal: true

module Types
  class UserNamespacePinType < Types::BaseObject
    description 'Represents a pinned namespace of a user'

    authorize :read_user_namespace_pin

    field :namespace, Types::NamespaceType, null: true, description: 'The pinned namespace'
    field :priority, Integer, null: false, description: 'Ordering priority of the pin, lower is higher priority'
    field :user, Types::UserType, null: false, description: 'The user owning this pin'

    id_field UserNamespacePin
    timestamps
  end
end
