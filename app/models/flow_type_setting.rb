# frozen_string_literal: true

class FlowTypeSetting < ApplicationRecord
  belongs_to :flow_type, inverse_of: :flow_type_settings

  UNIQUENESS_SCOPE = {
    unknown: 0,
    none: 1,
    project: 2,
  }.with_indifferent_access

  enum :unique, UNIQUENESS_SCOPE, prefix: :unique

  belongs_to :data_type

  validates :identifier, presence: true, uniqueness: { scope: :flow_type_id }
  validates :unique, presence: true,
                     inclusion: {
                       in: UNIQUENESS_SCOPE.keys.map(&:to_s),
                     },
                     exclusion: [0, :unknown, 'unknown']

  has_many :names, -> { by_purpose(:name) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :descriptions, -> { by_purpose(:description) }, class_name: 'Translation', as: :owner, inverse_of: :owner
end
