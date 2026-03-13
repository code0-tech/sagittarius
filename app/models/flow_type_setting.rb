# frozen_string_literal: true

class FlowTypeSetting < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :flow_type, inverse_of: :flow_type_settings

  UNIQUENESS_SCOPE = {
    unknown: 0,
    none: 1,
    project: 2,
  }.with_indifferent_access

  enum :unique, UNIQUENESS_SCOPE, prefix: :unique

  has_many :flow_type_setting_data_type_links, inverse_of: :flow_type_setting
  has_many :referenced_data_types, through: :flow_type_setting_data_type_links, source: :referenced_data_type

  validates :identifier, presence: true, uniqueness: { scope: :flow_type_id }
  validates :unique, presence: true,
                     inclusion: {
                       in: UNIQUENESS_SCOPE.keys.map(&:to_s),
                     },
                     exclusion: [0, :unknown, 'unknown']

  validates :type, presence: true, length: { maximum: 2000 }

  has_many :names, -> { by_purpose(:name) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :descriptions, -> { by_purpose(:description) }, class_name: 'Translation', as: :owner, inverse_of: :owner
end
