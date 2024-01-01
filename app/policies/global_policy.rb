# frozen_string_literal: true

class GlobalPolicy < BasePolicy
  rule { ~anonymous }.enable :create_team
end
