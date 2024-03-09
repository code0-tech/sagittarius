# frozen_string_literal: true

module Types
  class TeamType < Types::BaseObject
    description 'Represents a Team'

    authorize :read_team

    field :name, String, null: false, description: 'Name of the team'

    field :members, Types::OrganizationMemberType.connection_type, null: false, description: 'Members of the team',
                                                                   extras: [:lookahead]

    lookahead_field :members, base_scope: ->(object) { object.organization_members },
                              conditional_lookaheads: { user: :user, team: :team }

    id_field Team
    timestamps
  end
end
