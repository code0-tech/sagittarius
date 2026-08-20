# frozen_string_literal: true

Rails.application.configure do
  config.zero_track.active_record.timestamps = true
  config.zero_track.active_record.schema_migrations = true
  config.zero_track.active_record.schema_cleaner = true

  config.zero_track.db_partitioning.dynamic_partition_schema = 'sagittarius_partitions_dynamic'

  config.to_prepare do
    partition_manager = Code0::ZeroTrack::Database::Partitioning::PartitionManager
    partition_manager.reset_registered_models!

    partition_manager.register_model(AuditEvent)
    partition_manager.register_model(ExecutionResult)
    partition_manager.register_model(ExecutionNodeResult)
    partition_manager.register_model(ExecutionParameterResult)
    partition_manager.register_model(RuntimeModuleStatusDailyUptime)
    partition_manager.register_model(RuntimeStatusDailyUptime)
    partition_manager.register_model(RuntimeUsageDailyAggregate)
  end

  config.after_initialize do
    PartitionManagerSyncJob.perform_later if Rails.env.development? && defined?(Rails::Command::ServerCommand)
  end
end
