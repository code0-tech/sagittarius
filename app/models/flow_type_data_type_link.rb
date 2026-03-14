# frozen_string_literal: true

class FlowTypeDataTypeLink < ApplicationRecord
  belongs_to :flow_type, inverse_of: :flow_type_data_type_links
  belongs_to :referenced_data_type, class_name: 'DataType'
end
