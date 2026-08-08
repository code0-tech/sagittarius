# frozen_string_literal: true

class CreatePartitioningSchema < Code0::ZeroTrack::Database::Migration[1.0]
  def up
    create_dynamic_partition_schema
  end

  def down
    drop_dynamic_partition_schema
  end
end
