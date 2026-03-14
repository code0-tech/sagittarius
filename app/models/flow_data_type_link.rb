# frozen_string_literal: true

class FlowDataTypeLink < ApplicationRecord
  belongs_to :flow, inverse_of: :flow_data_type_links
  belongs_to :referenced_data_type, class_name: 'DataType'
end
