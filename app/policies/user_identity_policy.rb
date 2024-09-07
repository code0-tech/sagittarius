# frozen_string_literal: true

class UserIdentityPolicy < BasePolicy
  delegate { @subject.user }
end
