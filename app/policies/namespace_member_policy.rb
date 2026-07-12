# frozen_string_literal: true

class NamespaceMemberPolicy < BasePolicy
  delegate { subject.namespace }

  condition(:member_is_self) { subject.user.id == user&.id }
  condition(:personal_namespace_owner_member) { subject.namespace.personal_namespace_owner_member?(subject) }

  rule { member_is_self }.enable :delete_member

  rule { personal_namespace_owner_member }.prevent :delete_member
  rule { personal_namespace_owner_member }.prevent :assign_member_roles
end
