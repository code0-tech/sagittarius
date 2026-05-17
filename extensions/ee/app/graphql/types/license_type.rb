# frozen_string_literal: true

module Types
  class LicenseType < Types::BaseObject
    description '(EE only) Represents a License'

    authorize :read_license

    field :start_date, Types::TimeType, null: false, description: 'The start date of the license'

    field :end_date, Types::TimeType, null: true, description: 'The end date of the license'

    field :licensee, GraphQL::Types::JSON, null: false, description: 'The licensee information'

    expose_abilities %i[
      delete_license
    ]

    id_field License
    timestamps
  end
end

Types::LicenseType.prepend_extensions
