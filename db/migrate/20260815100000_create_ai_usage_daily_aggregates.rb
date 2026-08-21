# frozen_string_literal: true

class CreateAiUsageDailyAggregates < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    # One row per project per flow per day. flow_id defaults to 0 (NO_FLOW sentinel, see
    # AiUsageDailyAggregate) rather than being nullable, because a partitioned table's
    # primary key columns can't contain NULL - prompt-based generation of a brand-new flow
    # has no flow_id yet, so those rows share the sentinel instead of a real flow.
    # namespace_id is denormalized from the project at write time so namespace/application-
    # level usage can be read by filtering (or not filtering, for application-wide) this
    # single table instead of writing multiple rows per generation.
    #
    # No foreign keys on flow_id/project_id/namespace_id: usage rows are tied to the license
    # and must outlive their flow/project/namespace, so deleting those records must never
    # cascade or nullify here (flow_id/project_id are also part of the primary key, so
    # nullifying them would violate the PK anyway).
    create_partition_by_date_table :p_ai_usage_daily_aggregates,
                                   partition_column: :date,
                                   primary_key: %i[project_id flow_id date] do |t|
      t.bigint :flow_id, null: false, default: 0
      t.references :project, null: false, index: false
      t.references :namespace, null: false
      t.date :date, null: false
      t.bigint :generation_count, null: false, default: 0
      t.bigint :total_usage, null: false, default: 0

      t.timestamps_with_timezone
    end
  end
end
