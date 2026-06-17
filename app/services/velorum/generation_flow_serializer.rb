# frozen_string_literal: true

module Velorum
  class GenerationFlowSerializer
    def initialize(flow)
      @flow = flow
      @node_id_by_source_id = {}
      @generated_node_ids = {}.compare_by_identity
    end

    def to_h
      prepare_node_ids

      {
        name: flow.name,
        type: flow.type,
        starting_node_id: node_reference_id(flow.starting_node_id) || generated_starting_node_id,
        settings: flow.settings.map.with_index { |setting, index| flow_setting_to_h(setting, index) },
        nodes: flow.node_functions.map.with_index { |node, index| node_to_h(node, index) },
      }
    end

    private

    attr_reader :flow, :node_id_by_source_id, :generated_node_ids

    def prepare_node_ids
      flow.node_functions.each_with_index do |node, index|
        source_id = blank_zero(node.database_id)
        node_id = source_id&.to_s || "generated-#{index + 1}"

        node_id_by_source_id[source_id.to_s] = node_id if source_id.present?
        generated_node_ids[node] = node_id
      end
    end

    def node_to_h(node, index)
      {
        id: generated_node_ids.fetch(node),
        function_identifier: node.runtime_function_id,
        next_node_id: node_reference_id(node.next_node_id) || generated_next_node_id(index),
        definition_source: node.definition_source,
        parameters: node.parameters.map.with_index do |parameter, parameter_index|
          parameter_to_h(parameter, index, parameter_index)
        end,
      }
    end

    def parameter_to_h(parameter, node_index, parameter_index)
      {
        id: blank_zero(parameter.database_id) || "generated-parameter-#{node_index + 1}-#{parameter_index + 1}",
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
        { sub_flow_value: sub_flow_to_h(value.sub_flow) }
      else
        {}
      end
    end

    def reference_value_to_h(value)
      hash = {
        reference_path: value.paths.map { |path| reference_path_to_h(path) },
      }

      if value.input_type
        hash[:node_function_id] = node_reference_id(value.input_type.node_id)
        hash[:parameter_index] = blank_zero(value.input_type.parameter_index)
        hash[:input_index] = blank_zero(value.input_type.input_index)
      elsif !value.flow_input
        hash[:node_function_id] = node_reference_id(value.node_id)
      end

      hash
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
  end
end
