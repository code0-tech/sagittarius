# frozen_string_literal: true

class FlowTypeSetting < ApplicationRecord
  belongs_to :flow_type, inverse_of: :flow_type_settings

  belongs_to :data_type

  validates :identifier, presence: true, uniqueness: { scope: :flow_type_id }
  validates :unique, inclusion: { in: [true, false] }

  has_many :names, -> { by_purpose(:name) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :descriptions, -> { by_purpose(:description) }, class_name: 'Translation', as: :owner, inverse_of: :owner
end
