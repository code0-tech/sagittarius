# frozen_string_literal: true

class CreateGoodJobProcessLockIds < Sagittarius::Database::Migration[1.0]
  def change
    reversible do |dir|
      dir.up do
        # Ensure this incremental update migration is idempotent
        # with monolithic install migration.
        return if connection.column_exists?(:good_jobs, :locked_by_id)
      end
    end

    # rubocop:disable Rails/BulkChangeTable -- this is a migration from good_job gem
    add_column :good_jobs, :locked_by_id, :uuid
    add_column :good_jobs, :locked_at, :datetime_with_timezone
    add_column :good_job_executions, :process_id, :uuid
    add_column :good_job_processes, :lock_type, :integer, limit: 2
    # rubocop:enable Rails/BulkChangeTable
  end
end
