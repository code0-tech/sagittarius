# frozen_string_literal: true

class FlowType < ApplicationRecord
  belongs_to :runtime, inverse_of: :flow_types

  has_many :flow_type_settings, inverse_of: :flow_type

  has_many :flow_type_data_type_links, inverse_of: :flow_type
  has_many :referenced_data_types, through: :flow_type_data_type_links, source: :referenced_data_type

  validates :identifier, presence: true, uniqueness: { scope: :runtime_id }
  validates :editable, inclusion: { in: [true, false] }
  validates :signature, presence: true, length: { maximum: 500 }
  validates :definition_source, length: { maximum: 50 }
  validates :display_icon, length: { maximum: 100 }

  has_many :names, -> { by_purpose(:name) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :descriptions, -> { by_purpose(:description) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :documentations, -> { by_purpose(:documentation) }, class_name: 'Translation', as: :owner, inverse_of: :owner

  has_many :display_messages, -> { by_purpose(:display_message) },
           class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :aliases, -> { by_purpose(:alias) }, class_name: 'Translation', as: :owner, inverse_of: :owner

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
