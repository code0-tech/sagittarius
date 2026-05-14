# frozen_string_literal: true

class ModuleConfigurationDefinition < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :runtime_module, inverse_of: :module_configuration_definitions

  has_many :module_configuration_definition_data_type_links, inverse_of: :module_configuration_definition
  has_many :referenced_data_types,
           through: :module_configuration_definition_data_type_links,
           source: :referenced_data_type

  has_many :names, -> { by_purpose(:name) }, class_name: 'Translation', as: :owner, inverse_of: :owner
  has_many :descriptions, -> { by_purpose(:description) }, class_name: 'Translation', as: :owner, inverse_of: :owner

  validates :identifier, presence: true, length: { maximum: 50 }, uniqueness: { scope: :runtime_module_id }
  validates :type, presence: true, length: { maximum: 2000 }
  validates :optional, inclusion: { in: [true, false] }
  validates :hidden, inclusion: { in: [true, false] }
end
