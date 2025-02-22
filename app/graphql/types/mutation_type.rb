# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    description 'Root Mutation type'

    include Sagittarius::Graphql::MountMutation

    mount_mutation Mutations::ApplicationSettings::Update
    mount_mutation Mutations::Namespaces::Members::AssignRoles
    mount_mutation Mutations::Namespaces::Members::Delete
    mount_mutation Mutations::Namespaces::Members::Invite
    mount_mutation Mutations::Namespaces::Projects::Create
    mount_mutation Mutations::Namespaces::Projects::Update
    mount_mutation Mutations::Namespaces::Projects::Delete
    mount_mutation Mutations::Namespaces::Roles::AssignAbilities
    mount_mutation Mutations::Namespaces::Roles::AssignProjects
    mount_mutation Mutations::Namespaces::Roles::Create
    mount_mutation Mutations::Namespaces::Roles::Delete
    mount_mutation Mutations::Namespaces::Roles::Update
    mount_mutation Mutations::Organizations::Create
    mount_mutation Mutations::Organizations::Delete
    mount_mutation Mutations::Organizations::Update
    mount_mutation Mutations::Runtimes::Create
    mount_mutation Mutations::Runtimes::Delete
    mount_mutation Mutations::Runtimes::RotateToken
    mount_mutation Mutations::Runtimes::Update
    mount_mutation Mutations::Users::Identity::Link
    mount_mutation Mutations::Users::Identity::Login
    mount_mutation Mutations::Users::Identity::Register
    mount_mutation Mutations::Users::Identity::Unlink
    mount_mutation Mutations::Users::Mfa::BackupCodes::Rotate
    mount_mutation Mutations::Users::Mfa::Totp::GenerateSecret
    mount_mutation Mutations::Users::Mfa::Totp::ValidateSecret
    mount_mutation Mutations::Users::Login
    mount_mutation Mutations::Users::Logout
    mount_mutation Mutations::Users::Register
    mount_mutation Mutations::Users::Update
    mount_mutation Mutations::Echo
  end
end

Types::MutationType.prepend_extensions
