# frozen_string_literal: true

class Team < ApplicationRecord
  has_many :roles, inverse_of: :team
  has_many :team_members, inverse_of: :team

  validates :name, length: { maximum: 50 },
                   presence: true,
                   allow_blank: false,
                   uniqueness: { case_sensitive: false }
end
