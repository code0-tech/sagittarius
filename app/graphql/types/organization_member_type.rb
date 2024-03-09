# frozen_string_literal: true

module Types
  class OrganizationMemberType < Types::BaseObject
    description 'Represents an organization member'

    authorize :read_organization_member

    field :team, Types::TeamType, null: false, description: 'Team this member belongs to'
    field :user, Types::UserType, null: false, description: 'User this member belongs to'

    id_field OrganizationMember
    timestamps
  end
end
