# frozen_string_literal: true

class RuntimeModuleStatus < ApplicationRecord
  belongs_to :runtime_module, inverse_of: :runtime_module_status

  enum :status, RuntimeStatus::STATUS_TYPES, default: :unknown

  HEARTBEAT_WINDOW = RuntimeStatus::HEARTBEAT_WINDOW

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
