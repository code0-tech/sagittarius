# frozen_string_literal: true

class CreateUsageDailyAggregates < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_partition_by_date_table :p_flow_usage_daily_aggregates,
                                   partition_column: :date,
                                   primary_key: %i[flow_id date] do |t|
      t.references :flow, null: false, foreign_key: { to_table: :flows, on_delete: :cascade }, index: false
      t.date :date, null: false
      t.bigint :execution_count, null: false, default: 0
      t.bigint :total_execution_time_us, null: false, default: 0

      t.timestamps_with_timezone
    end

    create_partition_by_date_table :p_namespace_project_usage_daily_aggregates,
                                   partition_column: :date,
                                   primary_key: %i[project_id date] do |t|
      t.references :project,
                   null: false,
                   foreign_key: { to_table: :namespace_projects, on_delete: :cascade },
                   index: false
      t.date :date, null: false
      t.bigint :execution_count, null: false, default: 0
      t.bigint :total_execution_time_us, null: false, default: 0

      t.timestamps_with_timezone
    end

    create_partition_by_date_table :p_namespace_usage_daily_aggregates,
                                   partition_column: :date,
                                   primary_key: %i[namespace_id date] do |t|
      t.references :namespace, null: false, foreign_key: { to_table: :namespaces, on_delete: :cascade }, index: false
      t.date :date, null: false
      t.bigint :execution_count, null: false, default: 0
      t.bigint :total_execution_time_us, null: false, default: 0

      t.timestamps_with_timezone
    end

    create_partition_by_date_table :p_application_usage_daily_aggregates,
                                   partition_column: :date,
                                   primary_key: :date do |t|
      t.date :date, null: false
      t.bigint :execution_count, null: false, default: 0
      t.bigint :total_execution_time_us, null: false, default: 0

      t.timestamps_with_timezone
    end
  end
end
