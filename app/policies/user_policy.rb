# frozen_string_literal: true

class UserPolicy < BasePolicy
  condition(:user_is_self) { @subject.id == @user&.id }

  rule { ~anonymous }.enable :read_user

  rule { user_is_self }.policy do
    enable :manage_mfa
  end
end
