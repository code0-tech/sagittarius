# frozen_string_literal: true

class UserPolicy < BasePolicy
  condition(:user_is_self) { subject.id == user&.id }
  condition(:user_is_admin) { user&.admin? || false }
  condition(:admin_status_visible) { ApplicationSetting.current[:admin_status_visible] }

  rule { ~anonymous }.enable :read_user

  rule { user_is_admin }.policy do
    enable :update_user
    enable :read_user_identity
    enable :update_attachment_avatar
    enable :read_email
    enable :delete_user
    enable :read_admin_status
    enable :read_mfa_status
  end

  rule { admin_status_visible & ~anonymous }.enable :read_admin_status

  rule { user_is_self }.policy do
    enable :read_user_identity
    enable :manage_mfa
    enable :update_user
    enable :update_attachment_avatar
    enable :verify_email
    enable :send_verification_email
    enable :read_email
    enable :read_mfa_status
  end
end
