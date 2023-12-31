# frozen_string_literal: true

class TeamMember < ApplicationRecord
  belongs_to :team, inverse_of: :team_members
  belongs_to :user, inverse_of: :team_memberships

  validates :team, uniqueness: { scope: :user_id }
end
