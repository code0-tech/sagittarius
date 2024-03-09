# frozen_string_literal: true

module Types
  class OrganizationType < Types::BaseObject
    description 'Represents a Organization'

    authorize :read_organization

    field :name, String, null: false, description: 'Name of the organization'

    field :members, Types::OrganizationMemberType.connection_type, null: false,
                                                                   description: 'Members of the organization',
                                                                   extras: [:lookahead]

    lookahead_field :members, base_scope: ->(object) { object.organization_members },
                              conditional_lookaheads: { user: :user, organization: :organization }

    id_field Organization
    timestamps
  end
end
