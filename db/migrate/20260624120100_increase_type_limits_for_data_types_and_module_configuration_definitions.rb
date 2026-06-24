# frozen_string_literal: true

class IncreaseTypeLimitsForDataTypesAndModuleConfigurationDefinitions < Code0::ZeroTrack::Database::Migration[1.0]
  def change
    remove_check_constraint :data_types, 'char_length(type) <= 2000', name: 'check_01ca31b7b9'
    remove_check_constraint :module_configuration_definitions, 'char_length(type) <= 2000', name: 'check_7fe4a3bc1a'

    add_check_constraint :data_types, 'char_length(type) <= 8192', name: 'check_01ca31b7b9'
    add_check_constraint :module_configuration_definitions, 'char_length(type) <= 8192', name: 'check_7fe4a3bc1a'
  end
end
