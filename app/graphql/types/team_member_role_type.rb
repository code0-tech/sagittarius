# frozen_string_literal: true

module Types
  class TeamMemberRoleType < BaseObject
    description 'Represents an assigned role to a member'

    authorize :read_team_member_role

    field :member, Types::TeamMemberType, description: 'The member the role is assigned to'
    field :role, Types::TeamRoleType, description: 'The assigned role'

    id_field TeamMemberRole
    timestamps
  end
end
