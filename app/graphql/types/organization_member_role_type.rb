# frozen_string_literal: true

module Types
  class OrganizationMemberRoleType < BaseObject
    description 'Represents an assigned role to a member'

    authorize :read_organization_member_role

    field :member, Types::TeamMemberType, description: 'The member the role is assigned to'
    field :role, Types::TeamRoleType, description: 'The assigned role'

    id_field OrganizationMemberRole
    timestamps
  end
end
