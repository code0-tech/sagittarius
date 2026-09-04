# frozen_string_literal: true

class UserNamespacePinPolicy < BasePolicy
  condition(:pin_owner) { subject.user_id == user&.id }

  rule { pin_owner }.enable :read_user_namespace_pin
end
