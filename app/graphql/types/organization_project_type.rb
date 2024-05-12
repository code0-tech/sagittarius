# frozen_string_literal: true

module Types
  class OrganizationProjectType < Types::BaseObject
    description 'Represents a Organization project'

    authorize :read_organization_project

    field :name, String, null: false, description: 'Name of the project'
    field :description, String, null: false, description: 'Description of the project'

    field :organization, Types::OrganizationType, null: false,
          description: 'The organization where this project belongs to'

    id_field OrganizationProject
    timestamps
  end
end
