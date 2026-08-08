# frozen_string_literal: true

class RuntimeStatus < ApplicationRecord
  include TracksOutages

  belongs_to :runtime, inverse_of: :runtime_status
  has_many :daily_uptimes, class_name: 'RuntimeStatusDailyUptime', inverse_of: :runtime_status

  STATUS_TYPES = {
    not_responding: 0,
    not_ready: 1,
    running: 2,
    stopped: 3,
  }.with_indifferent_access

  enum :status, STATUS_TYPES, default: :not_responding

  validates :runtime_id, uniqueness: true
end
