# frozen_string_literal: true

class UserOrganizationPin < ApplicationRecord
  belongs_to :user, inverse_of: :user_organization_pins
  belongs_to :organization, inverse_of: :user_organization_pins

  validates :priority, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :organization_id, uniqueness: { scope: :user_id }
  validates :priority, uniqueness: { scope: :user_id }
end
