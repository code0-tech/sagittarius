# frozen_string_literal: true

class UserPolicy < BasePolicy
  condition(:user_is_self) { subject.id == user&.id }
  condition(:user_is_admin) { user.admin? }

  rule { ~anonymous }.enable :read_user

  rule { user_is_admin }.policy do
    enable :update_user
    enable :read_user_identity
    enable :update_attachment_avatar
  end

  rule { user_is_self }.policy do
    enable :read_user_identity
    enable :manage_mfa
    enable :update_user
    enable :update_attachment_avatar
  end
end
