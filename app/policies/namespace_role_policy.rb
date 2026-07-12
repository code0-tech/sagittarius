# frozen_string_literal: true

class NamespaceRolePolicy < BasePolicy
  delegate { subject.namespace }

  condition(:personal_namespace_owner_administrator_role) do
    subject.namespace.personal_namespace_owner_administrator_role?(subject)
  end

  rule { personal_namespace_owner_administrator_role }.policy do
    prevent :delete_namespace_role
    prevent :assign_role_abilities
    prevent :assign_role_projects
  end
end
