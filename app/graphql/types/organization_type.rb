# frozen_string_literal: true

module Types
  class OrganizationType < Types::BaseObject
    description 'Represents a Organization'

    authorize :read_organization

    field :name, String, null: false, description: 'Name of the organization'

    field :namespace, Types::NamespaceType,
          null: false,
          description: 'Namespace of this organization',
          method: :ensure_namespace

    id_field Organization
    timestamps
  end
end
