# frozen_string_literal: true

class UserPolicy < BasePolicy
  rule { ~anonymous }.enable :read_user
end
