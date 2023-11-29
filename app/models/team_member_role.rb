# frozen_string_literal: true

class TeamMemberRole < ApplicationRecord
  belongs_to :team_member, inverse_of: :team_member_roles
  belongs_to :role, inverse_of: :team_member_roles
end
