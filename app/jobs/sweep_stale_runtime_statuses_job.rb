# frozen_string_literal: true

class SweepStaleRuntimeStatusesJob < ApplicationJob
  def perform
    threshold = ApplicationSetting.current[:runtime_max_heartbeat_interval_minutes].minutes.ago

    sweep_stale_runtimes(threshold)
    sweep_stale_modules(threshold)
    roll_open_outages
  end

  private

  def sweep_stale_runtimes(threshold)
    RuntimeStatus.running.where(last_heartbeat: ...threshold).find_each do |runtime_status|
      runtime_status.record_status!(status: :not_responding)

      runtime_status.runtime.runtime_modules.find_each do |runtime_module|
        module_status = runtime_module.runtime_module_status
        next if module_status.nil? || !module_status.running?

        module_status.record_status!(status: :not_responding)
      end
    end
  end

  # Modules under a runtime that just went stale are already handled above (they're no longer
  # `running` by the time this query runs), so this only catches a single module going dark
  # while the rest of its runtime stays healthy.
  def sweep_stale_modules(threshold)
    RuntimeModuleStatus.running.where(last_heartbeat: ...threshold).find_each do |module_status|
      module_status.record_status!(status: :not_responding)
    end
  end

  def roll_open_outages
    RuntimeStatus.where.not(current_outage_started_at: nil).find_each(&:roll_outage_to_today!)
    RuntimeModuleStatus.where.not(current_outage_started_at: nil).find_each(&:roll_outage_to_today!)
  end
end
