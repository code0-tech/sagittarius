# frozen_string_literal: true

module Velorum
  class GenerationFlowSerializer
    class UnresolvedDefinitionError < StandardError
      attr_reader :details

      def initialize(message, details = {})
        @details = details
        super(message)
      end
    end

    def initialize(flow, project: nil)
      @flow = flow
      @project = project
      @node_id_by_source_id = {}
      @generated_node_ids = {}.compare_by_identity
      @function_definitions_by_runtime_id = {}
      @parameter_definitions_by_node = {}.compare_by_identity
      @flow_type_settings_by_flow_type = {}.compare_by_identity
      @generated_parameter_id_sequence = 0
      @generated_reference_path_id_sequence = 0
    end

    def to_h
      prepare_node_ids
      prepare_definition_ids
      flow_type = flow_type_for(flow.type)
      if runtime.present? && flow_type.nil?
        raise_unresolved_definition('Generated flow type is unknown', type: flow.type)
      end

      {
        name: flow.name,
        type: flow_type,
        starting_node_id: starting_node_id_for,
        settings: flow.settings.map.with_index { |setting, index| flow_setting_to_h(setting, index, flow_type) },
        nodes: serialized_nodes,
      }
    end

    private

    attr_reader :flow, :project, :node_id_by_source_id, :generated_node_ids, :function_definitions_by_runtime_id,
                :parameter_definitions_by_node, :flow_type_settings_by_flow_type

    def serialized_nodes
      @serialized_nodes ||= flow.node_functions.map.with_index { |node, index| node_to_h(node, index) }
    end

    def prepare_node_ids
      flow.node_functions.each_with_index do |node, index|
        source_id = blank_zero(node.database_id)
        node_id = source_id&.to_s || "generated-#{index + 1}"

        node_id_by_source_id[source_id.to_s] = node_id if source_id.present?
        generated_node_ids[node] = node_id
      end
    end

    def prepare_definition_ids
      return if runtime.nil?

      definitions = runtime.function_definitions
      if definitions.respond_to?(:includes)
        definitions = definitions.includes(:runtime_function_definition, :parameter_definitions)
      end
      definitions = definitions.respond_to?(:find_each) ? definitions.find_each : definitions.each

      definitions.each do |definition|
        next unless definition.respond_to?(:identifier)

        function_definitions_by_runtime_id[definition.identifier] ||= definition
        runtime_name = if definition.respond_to?(:runtime_function_definition)
                         definition.runtime_function_definition&.runtime_name
                       end
        function_definitions_by_runtime_id[runtime_name] ||= definition if runtime_name.present?
      end
    end

    def node_to_h(node, index)
      function_definition = function_definition_for(node)
      if runtime.present? && function_definition.nil?
        raise_unresolved_definition(
          'Generated function definition is unknown',
          runtime_function_id: node.runtime_function_id,
          node_index: index
        )
      end

      {
        id: generated_node_ids.fetch(node),
        function_definition: function_definition,
        next_node_id: next_node_id_for(node, index),
        parameters: node.parameters.map.with_index do |parameter, parameter_index|
          parameter_to_h(parameter, parameter_index, function_definition)
        end,
      }
    end

    def parameter_to_h(parameter, parameter_index, function_definition)
      parameter_definition = parameter_definition_for(function_definition, parameter_index)
      if runtime.present? && function_definition.present? && parameter_definition.nil?
        raise_unresolved_definition(
          'Generated parameter definition is unknown',
          function_definition_id: record_id(function_definition),
          runtime_parameter_id: parameter.runtime_parameter_id,
          parameter_index: parameter_index
        )
      end
      parameter_id = blank_zero(parameter.database_id) || generated_parameter_id

      {
        id: parameter_id,
        parameter_definition: parameter_definition,
        cast: blank_zero(parameter.cast),
        value: node_value_to_h(parameter.value, parameter_id),
      }
    end

    def node_value_to_h(value, id)
      return if value.nil?

      if value.literal_value
        {
          generated_value_type: :literal_value,
          value: value.literal_value.to_ruby(true),
        }
      elsif value.reference_value
        reference_value_to_h(value.reference_value, id)
      elsif value.sub_flow
        sub_flow_to_h(value.sub_flow)
      end
    end

    def reference_value_to_h(value, id)
      node_function_id = nil
      input_index = nil
      referenced_parameter_index = nil

      if value.input_type
        input_type = input_type_to_h(value.input_type)
        node_function_id = input_type[:node_id]
        referenced_parameter_index = input_type[:parameter_index]
        input_index = input_type[:input_index]
      elsif !value.flow_input
        node_function_id = node_reference_id(value.node_id)
      end

      {
        generated_value_type: :reference_value,
        id: id,
        node_function_id: node_function_id,
        parameter_index: referenced_parameter_index,
        input_index: input_index,
        input_type_identifier: nil,
        reference_path: value.paths.map { |path| reference_path_to_h(path) },
      }
    end

    def input_type_to_h(input_type)
      {
        node_id: node_reference_id(input_type.node_id),
        parameter_index: blank_zero(input_type.parameter_index),
        input_index: blank_zero(input_type.input_index),
      }
    end

    def reference_path_to_h(path)
      {
        id: generated_reference_path_id,
        path: path.path,
        array_index: blank_zero(path.array_index),
      }
    end

    def sub_flow_to_h(sub_flow)
      function_definition = function_definition_for_identifier(sub_flow.function_identifier)
      if runtime.present? && sub_flow.function_identifier.present? && function_definition.nil?
        raise_unresolved_definition(
          'Generated sub-flow function definition is unknown',
          function_identifier: sub_flow.function_identifier
        )
      end

      {
        generated_value_type: :sub_flow_value,
        starting_node_id: node_reference_id(sub_flow.starting_node_id),
        function_definition: function_definition,
        signature: sub_flow.signature,
        settings: sub_flow.settings.map { |setting| sub_flow_setting_to_h(setting) },
      }
    end

    def sub_flow_setting_to_h(setting)
      {
        identifier: setting.identifier,
        default_value: setting.default_value&.to_ruby(true),
        optional: setting.optional,
        hidden: setting.hidden,
      }
    end

    def flow_setting_to_h(setting, index, flow_type)
      flow_type_setting = flow_type_setting_for(flow_type, setting, index)
      if runtime.present? && flow_type.present? && flow_type_setting.nil?
        raise_unresolved_definition(
          'Generated flow setting is unknown',
          flow_type_id: record_id(flow_type),
          flow_setting_id: setting.flow_setting_id,
          flow_setting_index: index
        )
      end

      {
        id: blank_zero(setting.database_id) || (index + 1),
        flow_setting_identifier: flow_type_setting&.identifier || blank_zero(setting.flow_setting_id),
        flow_type_setting: flow_type_setting,
        value: setting.value&.to_ruby(true),
        cast: blank_zero(setting.cast),
      }
    end

    def node_reference_id(value)
      value = blank_zero(value)
      return if value.blank? || value.to_s == 'None'

      node_id_by_source_id.fetch(value.to_s, value)
    end

    def starting_node_id_for
      node_reference_id(flow.starting_node_id)
    end

    def generated_next_node_id(index)
      flow.node_functions[index + 1]&.then { |next_node| generated_node_ids.fetch(next_node) }
    end

    def next_node_id_for(node, index)
      node_reference_id(node.next_node_id) || (node.has_next_node_id? ? generated_next_node_id(index) : nil)
    end

    def blank_zero(value)
      return if value.blank? || value.to_s == '0'

      value
    end

    def function_definition_for(node)
      function_definition_for_identifier(node.runtime_function_id)
    end

    def function_definition_for_identifier(identifier)
      function_definitions_by_runtime_id[identifier]
    end

    def flow_type_for(identifier)
      return if runtime.nil?

      flow_types = runtime.flow_types
      flow_types = flow_types.includes(:flow_type_settings, :runtime_flow_type) if flow_types.respond_to?(:includes)

      if flow_types.respond_to?(:find_by)
        flow_types.find_by(identifier: identifier.to_s) ||
          flow_types.find { |flow_type| runtime_flow_type_identifier(flow_type) == identifier.to_s }
      else
        flow_types.find { |flow_type| flow_type.identifier == identifier.to_s } ||
          flow_types.find { |flow_type| runtime_flow_type_identifier(flow_type) == identifier.to_s }
      end
    end

    def runtime_flow_type_identifier(flow_type)
      return unless flow_type.respond_to?(:runtime_flow_type)

      flow_type.runtime_flow_type&.identifier
    end

    def parameter_definition_for(function_definition, index)
      return if function_definition.nil?

      parameter_definitions_by_node[function_definition] ||= ordered_parameter_definitions(function_definition)
      parameter_definitions_by_node[function_definition][index]
    end

    def ordered_parameter_definitions(function_definition)
      function_definition
        .parameter_definitions
        .sort_by { |definition| definition.runtime_parameter_definition&.id || definition.id }
    end

    def flow_type_setting_for(flow_type, setting, index)
      return if flow_type.nil?

      flow_type_settings_by_flow_type[flow_type] ||= flow_type.flow_type_settings.sort_by(&:id)
      flow_type_settings = flow_type_settings_by_flow_type[flow_type]

      return flow_type_settings[index] if index_identifier?(setting.flow_setting_id, 'setting')
      return flow_type_settings[index] if setting.flow_setting_id.blank?

      flow_type_settings.find { |type_setting| type_setting.identifier == setting.flow_setting_id }
    end

    def index_identifier?(identifier, prefix)
      identifier.to_s.match?(/\A#{Regexp.escape(prefix)}_\d+\z/)
    end

    def record_id(object)
      object.id if object.respond_to?(:id)
    end

    def generated_parameter_id
      @generated_parameter_id_sequence += 1
    end

    def generated_reference_path_id
      @generated_reference_path_id_sequence += 1
    end

    def raise_unresolved_definition(message, details)
      raise UnresolvedDefinitionError.new(message, details)
    end

    def runtime
      project&.primary_runtime
    end
  end
end
