# frozen_string_literal: true

class CreateUsageLimitNotifications < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    # Partitioned by billing cycle because the rows are transient: a claim only answers "has
    # this notification already gone out for this cycle", which stops being a question once the
    # cycle is over. Letting the partition manager drop whole past months keeps the table from
    # growing without bound and spares us a cleanup job (see UsageLimitNotification).
    #
    # No foreign key on namespace_id, like the usage aggregates this measures: a partition is
    # detached and dropped as a unit, and retention already removes the rows of a deleted
    # namespace. A leftover claim can never be mistaken for a live one either, since namespace
    # ids are not reused.
    create_partition_by_date_table :p_usage_limit_notifications,
                                   partition_column: :cycle_start do |t|
      # Nullable on purpose: EE licenses are installation-wide, so their notifications belong to
      # no namespace. Cloud licenses are per-namespace and fill this in (and require it, see
      # CLOUD::UsageLimitNotification).
      t.bigint :namespace_id, null: true
      t.integer :usage_kind, null: false, limit: 2
      t.integer :notification_kind, null: false, limit: 2
      t.date :cycle_start, null: false

      t.timestamps_with_timezone

      # Two partial indexes instead of one over all four columns: in Postgres NULLs are distinct
      # by default, so a plain unique index would let the installation-wide rows (namespace_id
      # IS NULL) be inserted over and over.
      t.index %i[namespace_id usage_kind notification_kind cycle_start],
              unique: true,
              where: 'namespace_id IS NOT NULL',
              name: 'index_usage_limit_notifications_on_namespace_scope'
      t.index %i[usage_kind notification_kind cycle_start],
              unique: true,
              where: 'namespace_id IS NULL',
              name: 'index_usage_limit_notifications_on_global_scope'
    end
  end
end
