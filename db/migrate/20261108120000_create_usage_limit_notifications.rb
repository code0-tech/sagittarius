# frozen_string_literal: true

class CreateUsageLimitNotifications < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    create_table :usage_limit_notifications do |t|
      # Nullable on purpose: EE licenses are installation-wide, so their notifications belong to
      # no namespace. Cloud licenses are per-namespace and fill this in. Cascading on delete is
      # right here (unlike for the usage aggregates, which outlive what they measured): a
      # notification only answers "has this already been sent", which stops being a question
      # once the namespace is gone.
      t.references :namespace, null: true, foreign_key: { on_delete: :cascade }, index: false
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
