# frozen_string_literal: true

class AddIndexGoodJobsConcurrencyKeyCreatedAt < Code0::ZeroTrack::Database::Migration[1.0]
  disable_ddl_transaction!

  def change
    reversible do |dir|
      dir.up do
        # Ensure this incremental update migration is idempotent
        # with monolithic install migration.
        return if connection.index_exists? :good_jobs, %i[concurrency_key created_at]
      end
    end

    add_index :good_jobs, %i[concurrency_key created_at], algorithm: :concurrently
  end
end
