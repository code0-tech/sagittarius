# frozen_string_literal: true

class UserSessionPolicy < BasePolicy
  condition(:session_owner) { @subject.user_id == @user&.id }

  rule { session_owner }.enable :logout_session
end
