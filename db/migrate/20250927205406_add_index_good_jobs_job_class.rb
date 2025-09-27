# frozen_string_literal: true

class AddIndexGoodJobsJobClass < Code0::ZeroTrack::Database::Migration[1.0]
  disable_ddl_transaction!

  def change
    reversible do |dir|
      dir.up do
        # Ensure this incremental update migration is idempotent
        # with monolithic install migration.
        return if connection.index_exists? :good_jobs, :job_class
      end
    end

    add_index :good_jobs, :job_class, algorithm: :concurrently
  end
end
