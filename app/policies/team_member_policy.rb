# frozen_string_literal: true

class TeamMemberPolicy < BasePolicy
  delegate { @subject.team }
end
