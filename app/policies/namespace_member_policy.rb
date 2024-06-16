# frozen_string_literal: true

class NamespaceMemberPolicy < BasePolicy
  delegate { @subject.namespace }
end
