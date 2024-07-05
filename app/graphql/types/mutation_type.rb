# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    description 'Root Mutation type'

    include Sagittarius::Graphql::MountMutation

    mount_mutation Mutations::ApplicationSettings::Update
    mount_mutation Mutations::NamespaceMembers::AssignRoles
    mount_mutation Mutations::NamespaceMembers::Delete
    mount_mutation Mutations::NamespaceMembers::Invite
    mount_mutation Mutations::NamespaceProjects::Create
    mount_mutation Mutations::NamespaceProjects::Update
    mount_mutation Mutations::NamespaceProjects::Delete
    mount_mutation Mutations::NamespaceRoles::AssignAbilities
    mount_mutation Mutations::NamespaceRoles::AssignProjects
    mount_mutation Mutations::NamespaceRoles::Create
    mount_mutation Mutations::NamespaceRoles::Delete
    mount_mutation Mutations::NamespaceRoles::Update
    mount_mutation Mutations::Organizations::Create
    mount_mutation Mutations::Organizations::Delete
    mount_mutation Mutations::Organizations::Update
    mount_mutation Mutations::Runtimes::Create
    mount_mutation Mutations::Runtimes::Delete
    mount_mutation Mutations::Runtimes::RotateToken
    mount_mutation Mutations::Runtimes::Update
    mount_mutation Mutations::Users::Login
    mount_mutation Mutations::Users::Logout
    mount_mutation Mutations::Users::Register
    mount_mutation Mutations::Echo
  end
end

Types::MutationType.prepend_extensions
