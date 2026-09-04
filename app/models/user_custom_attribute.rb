# frozen_string_literal: true

class UserCustomAttribute < ApplicationRecord
  belongs_to :user, inverse_of: :user_custom_attributes

  validates :key, presence: true,
                  allow_blank: false,
                  length: { maximum: 255 },
                  uniqueness: { scope: :user_id }
  validates :value, presence: true
end
