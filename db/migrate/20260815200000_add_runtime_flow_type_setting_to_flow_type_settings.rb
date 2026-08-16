# frozen_string_literal: true

class AddRuntimeFlowTypeSettingToFlowTypeSettings < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    add_reference :flow_type_settings, :runtime_flow_type_setting, foreign_key: { on_delete: :restrict }
    remove_column :flow_type_settings, :removed_at, :datetime_with_timezone
  end
end
