# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    description 'Root Mutation type'

    include Sagittarius::Graphql::MountMutation

    mount_mutation Mutations::ApplicationSettings::Update
    mount_mutation Mutations::OrganizationMembers::AssignRoles
    mount_mutation Mutations::OrganizationMembers::Delete
    mount_mutation Mutations::OrganizationMembers::Invite
    mount_mutation Mutations::OrganizationRoles::AssignAbilities
    mount_mutation Mutations::OrganizationRoles::Create
    mount_mutation Mutations::OrganizationRoles::Delete
    mount_mutation Mutations::OrganizationRoles::Update
    mount_mutation Mutations::Organizations::Create
    mount_mutation Mutations::Organizations::Update
    mount_mutation Mutations::Users::Login
    mount_mutation Mutations::Users::Logout
    mount_mutation Mutations::Users::Register
    mount_mutation Mutations::Echo
  end
end
