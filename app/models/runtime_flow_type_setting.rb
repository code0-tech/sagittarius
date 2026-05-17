# frozen_string_literal: true

class RuntimeFlowTypeSetting < ApplicationRecord
  include HasTranslation

  belongs_to :runtime_flow_type, inverse_of: :runtime_flow_type_settings

  UNIQUENESS_SCOPE = FlowTypeSetting::UNIQUENESS_SCOPE

  enum :unique, UNIQUENESS_SCOPE, prefix: :unique

  validates :identifier, presence: true, uniqueness: { scope: :runtime_flow_type_id }
  validates :unique, presence: true,
                     inclusion: {
                       in: UNIQUENESS_SCOPE.keys.map(&:to_s),
                     },
                     exclusion: [0, :unknown, 'unknown']
  validates :optional, inclusion: { in: [true, false] }
  validates :hidden, inclusion: { in: [true, false] }

  has_translation :names, purpose: :name
  has_translation :descriptions, purpose: :description

  scope :active, -> { where(removed_at: nil) }
  scope :removed, -> { where.not(removed_at: nil) }
end
