# frozen_string_literal: true

class NamespaceMemberPolicy < BasePolicy
  delegate { subject.namespace }

  condition(:member_is_self) { subject.user.id == user&.id }

  rule { member_is_self }.enable :delete_member
end
