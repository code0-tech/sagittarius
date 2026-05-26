# frozen_string_literal: true

class RuntimeFlowTypeDataTypeLink < ApplicationRecord
  belongs_to :runtime_flow_type, inverse_of: :runtime_flow_type_data_type_links
  belongs_to :referenced_data_type, class_name: 'DataType'
end
