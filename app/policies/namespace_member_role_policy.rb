# frozen_string_literal: true

class NamespaceMemberRolePolicy < BasePolicy
  delegate { subject.namespace_role }
end
