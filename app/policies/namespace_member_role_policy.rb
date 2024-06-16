# frozen_string_literal: true

class NamespaceMemberRolePolicy < BasePolicy
  delegate { @subject.role }
end
