# frozen_string_literal: true

class Team < ApplicationRecord
  validates :name, presence: true,
                   length: { minimum: 3, maximum: 50 },
                   allow_blank: false,
                   uniqueness: { case_sensitive: false }

  has_many :team_members, inverse_of: :team
  has_many :users, through: :team_members, inverse_of: :teams
end
