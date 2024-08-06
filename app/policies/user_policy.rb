# frozen_string_literal: true

class UserPolicy < BasePolicy
  condition(:user_is_self) { @subject.id == @user&.id }
  condition(:user_is_admin) { @user.is_admin? }


  rule { ~anonymous }.enable :read_user

  rule { user_is_admin }.policy do
    enable :update_user
  end

  rule { user_is_self }.policy do
    enable :manage_mfa
    enable :update_user
  end
end
