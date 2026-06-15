# frozen_string_literal: true

class FlowTypeSetting < ApplicationRecord
  include HasTranslation

  belongs_to :flow_type, inverse_of: :flow_type_settings

  UNIQUENESS_SCOPE = {
    unknown: 0,
    none: 1,
    project: 2,
  }.with_indifferent_access

  enum :unique, UNIQUENESS_SCOPE, prefix: :unique

  validates :identifier, presence: true, uniqueness: { scope: :flow_type_id }
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

  def to_grpc
    args = {
      identifier: identifier,
      unique: unique.to_s.upcase.to_sym,
      name: names.map(&:to_grpc),
      description: descriptions.map(&:to_grpc),
      optional: optional,
      hidden: hidden,
      default_value: Tucana::Shared::Value.from_ruby(default_value),
    }

    Tucana::Shared::FlowTypeSetting.new(**args)
  end
end
