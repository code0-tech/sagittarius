# frozen_string_literal: true

class RuntimeModuleStatus < ApplicationRecord
  include TracksOutages

  belongs_to :runtime_module, inverse_of: :runtime_module_status
  has_many :daily_uptimes, class_name: 'RuntimeModuleStatusDailyUptime', inverse_of: :runtime_module_status

  STATUS_TYPES = {
    not_responding: 0,
    not_ready: 1,
    running: 2,
    stopped: 3,
  }.with_indifferent_access

  enum :status, STATUS_TYPES, default: :not_responding

  validates :runtime_module_id, uniqueness: true
end
