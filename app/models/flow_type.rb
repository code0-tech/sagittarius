# frozen_string_literal: true

class FlowType < ApplicationRecord
  include HasTranslation

  belongs_to :runtime, inverse_of: :flow_types
  belongs_to :runtime_module, inverse_of: :flow_types
  belongs_to :runtime_flow_type, inverse_of: :flow_types

  has_many :flow_type_settings, inverse_of: :flow_type, autosave: true

  has_many :flow_type_data_type_links, inverse_of: :flow_type
  has_many :referenced_data_types, through: :flow_type_data_type_links, source: :referenced_data_type

  validates :identifier, presence: true, uniqueness: { scope: :runtime_id }
  validates :editable, inclusion: { in: [true, false] }
  validates :signature, presence: true, length: { maximum: 500 }
  validates :definition_source, length: { maximum: 50 }
  validates :display_icon, length: { maximum: 100 }

  has_translation :names, purpose: :name
  has_translation :descriptions, purpose: :description
  has_translation :documentations, purpose: :documentation

  has_translation :display_messages, purpose: :display_message
  has_translation :aliases, purpose: :alias

  validate :validate_version

  def validate_version
    return errors.add(:version, :blank) if version.blank?

    parsed_version
  rescue ArgumentError
    errors.add(:version, :invalid)
  end

  def parsed_version
    Gem::Version.new(version)
  end
end
