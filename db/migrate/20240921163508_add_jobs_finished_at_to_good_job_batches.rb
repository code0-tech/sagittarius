# frozen_string_literal: true

class AddJobsFinishedAtToGoodJobBatches < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    reversible do |dir|
      dir.up do
        # Ensure this incremental update migration is idempotent
        # with monolithic install migration.
        return if connection.column_exists?(:good_job_batches, :jobs_finished_at)
      end
    end

    change_table :good_job_batches do |t|
      t.datetime_with_timezone :jobs_finished_at
    end
  end
end
