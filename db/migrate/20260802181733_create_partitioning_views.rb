# frozen_string_literal: true

class CreatePartitioningViews < Code0::ZeroTrack::Database::Migration[1.0]
  def up
    create_partitioning_views
  end

  def down
    drop_partitioning_views
  end
end
