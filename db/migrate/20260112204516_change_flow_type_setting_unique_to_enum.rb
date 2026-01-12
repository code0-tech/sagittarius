# frozen_string_literal: true

class ChangeFlowTypeSettingUniqueToEnum < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    remove_column :flow_type_settings, :unique, :boolean, null: false, default: false
    add_column :flow_type_settings, :unique, :integer, null: false, default: 0
  end
end
