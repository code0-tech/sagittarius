# frozen_string_literal: true

class UserCustomAttribute < ApplicationRecord
  belongs_to :user, inverse_of: :user_custom_attributes

  validates :key, presence: true,
                  allow_blank: false,
                  length: { maximum: 255 },
                  uniqueness: { scope: :user_id }
  validate :value_must_not_be_nil

  private

  def value_must_not_be_nil
    errors.add(:value, :blank) if value.nil?
  end
end
