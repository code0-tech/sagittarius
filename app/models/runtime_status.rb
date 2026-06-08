# frozen_string_literal: true

class RuntimeStatus < ApplicationRecord
  belongs_to :runtime, inverse_of: :runtime_status

  STATUS_TYPES = {
    not_responding: 0,
    not_ready: 1,
    running: 2,
    stopped: 3,
    unknown: 4,
  }.with_indifferent_access

  enum :status, STATUS_TYPES, default: :stopped

  HEARTBEAT_WINDOW = 10.minutes

  def self.status_for_heartbeat(last_heartbeat)
    last_heartbeat && last_heartbeat >= HEARTBEAT_WINDOW.ago ? :running : :not_responding
  end

  def current_status
    return 'not_responding' if last_heartbeat.blank?
    return 'not_responding' if last_heartbeat < HEARTBEAT_WINDOW.ago

    status
  end

  def uptime
    current_status == 'not_responding' ? 0.0 : 100.0
  end

  def uptimes
    Array.new(14, uptime)
  end
end
