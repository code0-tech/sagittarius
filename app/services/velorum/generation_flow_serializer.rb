# frozen_string_literal: true

module Velorum
  class GenerationFlowSerializer
    def initialize(flow, project: nil)
      @flow = flow
      @project = project
      @node_id_by_source_id = {}
      @generated_node_ids = {}.compare_by_identity
      @function_definitions_by_runtime_id = {}
      @parameter_definitions_by_node = {}.compare_by_identity
    end

    def to_h
      prepare_node_ids
      prepare_definition_ids

      {
        name: flow.name,
        type: flow.type,
        starting_node_id: node_reference_id(flow.starting_node_id) || generated_starting_node_id,
        settings: flow.settings.map.with_index { |setting, index| flow_setting_to_h(setting, index) },
        nodes: serialized_nodes,
      }
    end

    private

    attr_reader :flow, :project, :node_id_by_source_id, :generated_node_ids, :function_definitions_by_runtime_id,
                :parameter_definitions_by_node

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

      {
        id: generated_node_ids.fetch(node),
        function_definition: function_definition,
        function_identifier: node.runtime_function_id,
        next_node_id: node_reference_id(node.next_node_id) || generated_next_node_id(index),
        definition_source: node.definition_source,
        parameters: node.parameters.map.with_index do |parameter, parameter_index|
          parameter_to_h(parameter, index, parameter_index, function_definition)
        end,
      }
    end

    def parameter_to_h(parameter, node_index, parameter_index, function_definition)
      parameter_definition = parameter_definition_for(function_definition, parameter_index)

      {
        id: blank_zero(parameter.database_id) || "generated-parameter-#{node_index + 1}-#{parameter_index + 1}",
        parameter_definition_id: parameter_definition&.id,
        parameter_identifier: parameter.runtime_parameter_id,
        cast: parameter.cast,
        value: node_value_to_h(parameter.value),
      }
    end

    def node_value_to_h(value)
      return {} if value.nil?

      if value.literal_value
        { literal_value: value.literal_value.to_ruby(true) }
      elsif value.reference_value
        { reference_value: reference_value_to_h(value.reference_value) }
      elsif value.sub_flow
        sub_flow = sub_flow_to_h(value.sub_flow)
        { sub_flow: sub_flow, sub_flow_value: sub_flow }
      else
        {}
      end
    end

    def reference_value_to_h(value)
      hash = {
        flow_input: value.flow_input.present?,
        reference_path: value.paths.map { |path| reference_path_to_h(path) },
      }

      if value.input_type
        input_type = input_type_to_h(value.input_type)
        hash[:input_type] = input_type
        hash[:node_function_id] = input_type[:node_id]
        hash[:parameter_index] = blank_zero(value.input_type.parameter_index)
        hash[:input_index] = blank_zero(value.input_type.input_index)
      elsif !value.flow_input
        hash[:node_id] = node_reference_id(value.node_id)
        hash[:node_function_id] = hash[:node_id]
      end

      hash
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
        path: path.path,
        array_index: blank_zero(path.array_index),
      }
    end

    def sub_flow_to_h(sub_flow)
      {
        starting_node_id: node_reference_id(sub_flow.starting_node_id),
        function_identifier: sub_flow.function_identifier,
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

    def flow_setting_to_h(setting, index)
      {
        id: blank_zero(setting.database_id) || "generated-setting-#{index + 1}",
        flow_setting_id: setting.flow_setting_id,
        value: setting.value&.to_ruby(true),
        cast: setting.cast,
      }
    end

    def node_reference_id(value)
      value = blank_zero(value)
      return if value.blank?

      node_id_by_source_id.fetch(value.to_s, value)
    end

    def generated_starting_node_id
      generated_node_ids.values.first
    end

    def generated_next_node_id(index)
      flow.node_functions[index + 1]&.then { |next_node| generated_node_ids.fetch(next_node) }
    end

    def blank_zero(value)
      return if value.blank? || value.to_s == '0'

      value
    end

    def function_definition_for(node)
      function_definitions_by_runtime_id[node.runtime_function_id]
    end

    def parameter_definition_for(function_definition, index)
      return if function_definition.nil?

      parameter_definitions_by_node[function_definition] ||= function_definition.parameter_definitions.to_a
      parameter_definitions_by_node[function_definition][index]
    end

    def runtime
      project&.primary_runtime
    end
  end
end
