# frozen_string_literal: true

class CreateIndexGoodJobJobsForCandidateLookup < Sagittarius::Database::Migration[1.0]
  disable_ddl_transaction!

  def change
    reversible do |dir|
      dir.up do
        # Ensure this incremental update migration is idempotent
        # with monolithic install migration.
        return if connection.index_name_exists?(:good_jobs, :index_good_job_jobs_for_candidate_lookup)
      end
    end

    # rubocop:disable Layout/LineLength -- this is a migration from good_job gem
    add_index :good_jobs, %i[priority created_at], order: { priority: 'ASC NULLS LAST', created_at: :asc },
                                                   where: 'finished_at IS NULL', name: :index_good_job_jobs_for_candidate_lookup,
                                                   algorithm: :concurrently
    # rubocop:enable Layout/LineLength
  end
end
