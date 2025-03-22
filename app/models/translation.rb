# frozen_string_literal: true

class Translation < ApplicationRecord
  belongs_to :owner, polymorphic: true

  validates :code, presence: true
  validates :content, presence: true

  scope :by_purpose, ->(purpose) { where(purpose: purpose) }
end
