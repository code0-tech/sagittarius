# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    description 'Root Mutation type'

    include Sagittarius::Graphql::MountMutation

    mount_mutation Mutations::ApplicationSettings::Update
    mount_mutation Mutations::TeamMembers::AssignRoles
    mount_mutation Mutations::TeamMembers::Invite
    mount_mutation Mutations::TeamRoles::AssignAbilities
    mount_mutation Mutations::TeamRoles::Create
    mount_mutation Mutations::Teams::Create
    mount_mutation Mutations::Users::Login
    mount_mutation Mutations::Users::Logout
    mount_mutation Mutations::Users::Register
    mount_mutation Mutations::Echo
  end
end
