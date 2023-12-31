# frozen_string_literal: true

module Types
  class TeamType < Types::BaseObject
    description 'Represents a Team'

    authorize :read_team

    field :name, String, null: false, description: 'Name of the team'

    id_field Team
    timestamps
  end
end
