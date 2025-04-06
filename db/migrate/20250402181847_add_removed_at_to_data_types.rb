# frozen_string_literal: true

class AddRemovedAtToDataTypes < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :data_types, :removed_at, :datetime_with_timezone
  end
end
