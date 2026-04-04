# frozen_string_literal: true

class UpdateFlowAndFlowTypeToTucana0066 < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    remove_column :flow_types, :input_type, :text, limit: 2000
    remove_column :flow_types, :return_type, :text, limit: 2000
    add_column :flow_types, :signature, :text, null: false, default: ''
    add_check_constraint :flow_types, 'char_length(signature) <= 500'

    remove_column :flows, :input_type, :text, limit: 2000
    remove_column :flows, :return_type, :text, limit: 2000
    add_column :flows, :signature, :text, null: false, default: ''
    add_check_constraint :flows, 'char_length(signature) <= 500'

    remove_column :flow_type_settings, :type, :text, null: false, limit: 2000

    drop_table :flow_type_setting_data_type_links do |t|
      t.references :flow_type_setting, null: false,
                                       foreign_key: { on_delete: :cascade },
                                       index: false
      t.references :referenced_data_type, null: false,
                                          foreign_key: { to_table: :data_types, on_delete: :restrict },
                                          index: false

      t.index %i[flow_type_setting_id referenced_data_type_id], unique: true

      t.timestamps_with_timezone
    end
  end
end
