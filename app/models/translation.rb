# frozen_string_literal: true

class Translation < ApplicationRecord
  belongs_to :owner, polymorphic: true

  validates :code, presence: true
  validates :content, presence: true

  scope :by_purpose, ->(purpose) { where(purpose: purpose) }

  def to_grpc
    Tucana::Shared::Translation.new(
      code: code,
      content: content
    )
  end
end
