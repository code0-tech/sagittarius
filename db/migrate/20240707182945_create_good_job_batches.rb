# frozen_string_literal: true

class CreateGoodJobBatches < Sagittarius::Database::Migration[1.0]
  def change
    reversible do |dir|
      dir.up do
        # Ensure this incremental update migration is idempotent
        # with monolithic install migration.
        return if connection.table_exists?(:good_job_batches)
      end
    end

    create_table :good_job_batches, id: :uuid do |t|
      t.timestamps_with_timezone
      t.text :description
      t.jsonb :serialized_properties
      t.text :on_finish
      t.text :on_success
      t.text :on_discard
      t.text :callback_queue_name
      t.integer :callback_priority
      t.datetime_with_timezone :enqueued_at
      t.datetime_with_timezone :discarded_at
      t.datetime_with_timezone :finished_at
    end

    change_table :good_jobs do |t|
      t.uuid :batch_id
      t.uuid :batch_callback_id

      t.index :batch_id, where: 'batch_id IS NOT NULL'
      t.index :batch_callback_id, where: 'batch_callback_id IS NOT NULL'
    end
  end
end
