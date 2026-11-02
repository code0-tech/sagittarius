# frozen_string_literal: true

class InstallPolymorphicCleanupTriggers < Code0::ZeroTrack::Database::Migration[1.1]
  # rubocop:disable-next Layout/LineLength -- reads nicer with an entry per line
  POLYMORPHIC_ASSOCIATIONS = [
    # namespaces.parent => Organization | User
    { table: :namespaces, parent_table: :organizations, parent_column: :parent, parent_class: 'Organization' },
    { table: :namespaces, parent_table: :users, parent_column: :parent, parent_class: 'User' },

    # translations.owner => every model including HasTranslation
    { table: :translations, parent_table: :data_types, parent_column: :owner, parent_class: 'DataType' },
    { table: :translations, parent_table: :flow_types, parent_column: :owner, parent_class: 'FlowType' },
    { table: :translations, parent_table: :flow_type_settings, parent_column: :owner, parent_class: 'FlowTypeSetting' },
    { table: :translations, parent_table: :function_definitions, parent_column: :owner, parent_class: 'FunctionDefinition' },
    { table: :translations, parent_table: :module_configuration_definitions, parent_column: :owner, parent_class: 'ModuleConfigurationDefinition' },
    { table: :translations, parent_table: :parameter_definitions, parent_column: :owner, parent_class: 'ParameterDefinition' },
    { table: :translations, parent_table: :runtime_flow_types, parent_column: :owner, parent_class: 'RuntimeFlowType' },
    { table: :translations, parent_table: :runtime_flow_type_settings, parent_column: :owner, parent_class: 'RuntimeFlowTypeSetting' },
    { table: :translations, parent_table: :runtime_function_definitions, parent_column: :owner, parent_class: 'RuntimeFunctionDefinition' },
    { table: :translations, parent_table: :runtime_modules, parent_column: :owner, parent_class: 'RuntimeModule' },
    { table: :translations, parent_table: :runtime_parameter_definitions, parent_column: :owner, parent_class: 'RuntimeParameterDefinition' }
  ].freeze

  def up
    POLYMORPHIC_ASSOCIATIONS.each do |a|
      create_polymorphic_cleanup_trigger(a[:table], a[:parent_table], a[:parent_column], a[:parent_class])
    end
  end

  def down
    POLYMORPHIC_ASSOCIATIONS.reverse_each do |a|
      drop_polymorphic_cleanup_trigger(a[:table], a[:parent_table], a[:parent_column])
    end
  end
end
