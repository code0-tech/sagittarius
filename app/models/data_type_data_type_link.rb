# frozen_string_literal: true

class DataTypeDataTypeLink < ApplicationRecord
  belongs_to :data_type, inverse_of: :data_type_data_type_links
  belongs_to :referenced_data_type, class_name: 'DataType'
end
