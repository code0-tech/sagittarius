# frozen_string_literal: true

class FlowType < ApplicationRecord
  belongs_to :runtime

  belongs_to :input_type, class_name: 'DataType', optional: true
  belongs_to :return_type, class_name: 'DataType', optional: true

  has_many :flow_type_settings, inverse_of: :flow_type

  validates :identifier, presence: true, uniqueness: { scope: :runtime_id }
  validates :editable, inclusion: { in: [true, false] }

  has_many :names, -> { by_purpose(:name) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :descriptions, -> { by_purpose(:description) }, class_name: 'Translation', as: :owner, inverse_of: :owner
end
