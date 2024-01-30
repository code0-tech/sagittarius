# frozen_string_literal: true

class TeamMember < ApplicationRecord
  belongs_to :team, inverse_of: :team_members
  belongs_to :user, inverse_of: :team_memberships

  has_many :member_roles, class_name: 'TeamMemberRole', inverse_of: :member
  has_many :roles, class_name: 'TeamRole', through: :member_roles, inverse_of: :members

  validates :team, uniqueness: { scope: :user_id }
end
