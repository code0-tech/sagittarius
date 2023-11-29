# frozen_string_literal: true

class Role < ApplicationRecord
  belongs_to :team, inverse_of: :roles
  has_many :role_policies, inverse_of: :role
  has_many :team_member_roles, inverse_of: :role

  validates :name, length: { maximum: 50 },
                   presence: true,
                   allow_blank: false
end
