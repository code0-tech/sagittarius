# frozen_string_literal: true

class UserOrganizationPinPolicy < BasePolicy
  delegate { subject.user }

  condition(:user_is_self) { subject.id == user&.id }

  rule { user_is_self }.enable :read_user_organization_pin
end
