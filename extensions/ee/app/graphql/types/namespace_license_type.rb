# frozen_string_literal: true

module Types
  class NamespaceLicenseType < Types::BaseObject
    description 'Represents a Namespace License'

    authorize :read_namespace_license

    field :namespace, Types::NamespaceType, null: false, description: 'The namespace the license belongs to'

    id_field NamespaceLicense
    timestamps
  end
end
