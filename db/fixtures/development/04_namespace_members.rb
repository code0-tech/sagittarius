# frozen_string_literal: true

NamespaceMember.seed_once :namespace_id, :user_id do |nm|
  nm.namespace_id = Organization.find_by(name: 'Code1').ensure_namespace.id
  nm.user_id = User.find_by(username: 'User').id
  nm.roles = [
    NamespaceRole.find_by(
      name: 'Member',
      namespace_id: Organization.find_by(name: 'Code1').ensure_namespace.id
    )
  ]
end

NamespaceMember.seed_once :namespace_id, :user_id do |nm|
  nm.namespace_id = Organization.find_by(name: 'Code1').ensure_namespace.id
  nm.user_id = User.find_by(username: 'Maintainer').id
  nm.roles = [
    NamespaceRole.find_by(
      name: 'Maintainer',
      namespace_id: Organization.find_by(name: 'Code1').ensure_namespace.id
    ),
    NamespaceRole.find_by(
      name: 'Member',
      namespace_id: Organization.find_by(name: 'Code1').ensure_namespace.id
    )
  ]
end

NamespaceMember.seed_once :namespace_id, :user_id do |nm|
  nm.namespace_id = Organization.find_by(name: 'Code1').ensure_namespace.id
  nm.user_id = User.find_by(username: 'Owner').id
  nm.roles = [
    NamespaceRole.find_by(
      name: 'Owner',
      namespace_id: Organization.find_by(name: 'Code1').ensure_namespace.id
    )
  ]
end
