# frozen_string_literal: true

class Flow < ApplicationRecord
  belongs_to :project, class_name: 'NamespaceProject'
  belongs_to :flow_type
  belongs_to :input_type_identifier, class_name: 'DataTypeIdentifier', optional: true
  belongs_to :return_type_identifier, class_name: 'DataTypeIdentifier', optional: true
  belongs_to :starting_node, class_name: 'NodeFunction'

  has_many :flow_settings, dependent: :destroy
end
