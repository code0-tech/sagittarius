# frozen_string_literal: true

class TeamRole < ApplicationRecord
  belongs_to :team, inverse_of: :roles

  validates :name, presence: true,
                   length: { minimum: 3, maximum: 50 },
                   allow_blank: false,
                   uniqueness: { case_sensitive: false, scope: :team_id }
end
