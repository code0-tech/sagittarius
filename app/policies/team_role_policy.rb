# frozen_string_literal: true

class TeamRolePolicy < BasePolicy
  delegate { @subject.team }
end
