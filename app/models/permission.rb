# frozen_string_literal: true

class Permission < ApplicationRecord
  has_many :policies, inverse_of: :permission

  validates :name, length: { maximum: 50 },
                   presence: true,
                   allow_blank: false,
                   uniqueness: { case_sensitive: false }
end
