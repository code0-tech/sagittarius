# frozen_string_literal: true

class CreateRuntimeUsageDailyAggregates < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    # One row per flow per day. project_id/namespace_id are denormalized from the flow at
    # write time so project/namespace/application-level usage can be read by filtering (or
    # not filtering, for application-wide) this single table instead of writing multiple
    # rows per execution.
    create_partition_by_date_table :p_runtime_usage_daily_aggregates,
                                   partition_column: :date,
                                   primary_key: %i[flow_id date] do |t|
      t.references :flow, null: false, foreign_key: { to_table: :flows, on_delete: :nullify }, index: false
      t.references :project,
                   null: false,
                   foreign_key: { to_table: :namespace_projects, on_delete: :nullify }
      t.references :namespace, null: false, foreign_key: { on_delete: :nullify }
      t.date :date, null: false
      t.bigint :execution_count, null: false, default: 0
      t.bigint :total_execution_time_us, null: false, default: 0

      t.timestamps_with_timezone
    end
  end
end
