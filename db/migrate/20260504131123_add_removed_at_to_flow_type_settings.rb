# frozen_string_literal: true

class AddRemovedAtToFlowTypeSettings < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_column :flow_type_settings, :removed_at, :datetime_with_timezone
  end
end
