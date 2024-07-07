# frozen_string_literal: true

class CreateIndexGoodJobsJobsOnPriorityCreatedAtWhenUnfinished < Sagittarius::Database::Migration[1.0]
  disable_ddl_transaction!

  def change
    reversible do |dir|
      dir.up do
        # Ensure this incremental update migration is idempotent
        # with monolithic install migration.
        return if connection.index_name_exists?(:good_jobs,
                                                :index_good_jobs_jobs_on_priority_created_at_when_unfinished)
      end
    end

    # rubocop:disable Layout/LineLength -- this is a migration from good_job gem
    add_index :good_jobs, %i[priority created_at], order: { priority: 'DESC NULLS LAST', created_at: :asc },
                                                   where: 'finished_at IS NULL', name: :index_good_jobs_jobs_on_priority_created_at_when_unfinished,
                                                   algorithm: :concurrently
    # rubocop:enable Layout/LineLength
  end
end
