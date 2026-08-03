# frozen_string_literal: true

class RuntimeStatusDailyUptime < ApplicationRecord
  belongs_to :runtime_status, inverse_of: :daily_uptimes

  validates :date, presence: true, uniqueness: { scope: :runtime_status_id }
end
