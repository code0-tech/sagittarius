# frozen_string_literal: true

class RuntimeModule < ApplicationRecord
  belongs_to :runtime, inverse_of: :runtime_modules

  has_many :data_types, inverse_of: :runtime_module
  has_many :runtime_flow_types, inverse_of: :runtime_module
  has_many :flow_types, inverse_of: :runtime_module
  has_many :runtime_function_definitions, inverse_of: :runtime_module
  has_many :function_definitions, through: :runtime_function_definitions
  has_many :module_configuration_definitions, inverse_of: :runtime_module

  has_many :names, -> { by_purpose(:name) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :descriptions, -> { by_purpose(:description) }, class_name: 'Translation', as: :owner, inverse_of: :owner

  validates :identifier, presence: true,
                         length: { maximum: 50 },
                         uniqueness: { case_sensitive: false, scope: :runtime_id }
  validates :documentation, length: { maximum: 2000 }, exclusion: { in: [nil] }
  validates :author, length: { maximum: 200 }, exclusion: { in: [nil] }
  validates :icon, length: { maximum: 100 }

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
