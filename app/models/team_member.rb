# frozen_string_literal: true

class TeamMember < ApplicationRecord
  belongs_to :team, inverse_of: :team_members
  belongs_to :user, inverse_of: :team_members

  has_many :team_member_roles, inverse_of: :team_member
end
