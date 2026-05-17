# frozen_string_literal: true

class AddLockTypeToGoodJobs < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :good_jobs, :lock_type, :integer, limit: 2 unless column_exists?(:good_jobs, :lock_type)
  end
end
