# frozen_string_literal: true

class RuntimeModuleStatusDailyUptime < ApplicationRecord
  belongs_to :runtime_module_status, inverse_of: :daily_uptimes

  validates :date, presence: true, uniqueness: { scope: :runtime_module_status_id }
end
