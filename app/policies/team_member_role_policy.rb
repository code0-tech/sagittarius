# frozen_string_literal: true

class TeamMemberRolePolicy < BasePolicy
  delegate { @subject.role.team }
end
