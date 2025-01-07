# frozen_string_literal: true

class NamespaceRolePolicy < BasePolicy
  delegate { subject.namespace }
end
