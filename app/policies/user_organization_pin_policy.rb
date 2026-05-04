# frozen_string_literal: true

class UserOrganizationPinPolicy < BasePolicy
  delegate { subject.user }

  rule { can?(:read_user) }.enable :read_user_organization_pin
end
