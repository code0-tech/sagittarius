# frozen_string_literal: true

require Rails.root.join('lib/sagittarius/database/polymorphic_cleanup_trigger')

class AddTranslationCleanupTriggers < Code0::ZeroTrack::Database::Migration[1.0]
  include Sagittarius::Database::PolymorphicCleanupTrigger

  TRANSLATION_OWNERS = {
    data_types: 'DataType',
    flow_types: 'FlowType',
    flow_type_settings: 'FlowTypeSetting',
    function_definitions: 'FunctionDefinition',
    module_configuration_definitions: 'ModuleConfigurationDefinition',
    parameter_definitions: 'ParameterDefinition',
    runtime_flow_types: 'RuntimeFlowType',
    runtime_flow_type_settings: 'RuntimeFlowTypeSetting',
    runtime_function_definitions: 'RuntimeFunctionDefinition',
    runtime_modules: 'RuntimeModule',
    runtime_parameter_definitions: 'RuntimeParameterDefinition',
  }.freeze

  def up
    TRANSLATION_OWNERS.each do |parent_table, parent_class|
      create_polymorphic_cleanup_trigger(:translations, parent_table, :owner, parent_class)
    end
  end

  def down
    TRANSLATION_OWNERS.each_key do |parent_table|
      drop_polymorphic_cleanup_trigger(:translations, parent_table)
    end
  end
end
