# frozen_string_literal: true

module Types
  class NamespaceLicenseType < Types::BaseObject
    description '(EE only) Represents a Namespace License'

    authorize :read_namespace_license

    field :namespace, Types::NamespaceType, null: false, description: 'The namespace the license belongs to'

    field :start_date, Types::TimeType, null: false, description: 'The start date of the license'

    field :end_date, Types::TimeType, null: true, description: 'The end date of the license'

    field :licensee, GraphQL::Types::JSON, null: false, description: 'The licensee information'

    expose_abilities %i[
      delete_namespace_license
    ]

    id_field NamespaceLicense
    timestamps
  end
end
