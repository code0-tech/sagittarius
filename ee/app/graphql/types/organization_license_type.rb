# frozen_string_literal: true

module Types
  class OrganizationLicenseType < Types::BaseObject
    description 'Represents a Organization License'

    authorize :read_organization_license

    field :organization, Types::OrganizationType, null: false, description: 'The organization the license belongs to'

    id_field OrganizationLicense
    timestamps
  end
end
