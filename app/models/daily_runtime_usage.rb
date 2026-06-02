# frozen_string_literal: true

class DailyRuntimeUsage < ApplicationRecord
  belongs_to :flow, optional: true, inverse_of: :daily_runtime_usages
  belongs_to :namespace, inverse_of: :daily_runtime_usages

  validates :day, presence: true
  validates :usage, numericality: { greater_than_or_equal_to: 0 }
end
