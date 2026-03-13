# frozen_string_literal: true

class FlowTypeSettingDataTypeLink < ApplicationRecord
  belongs_to :flow_type_setting, inverse_of: :flow_type_setting_data_type_links
  belongs_to :referenced_data_type, class_name: 'DataType'
end
