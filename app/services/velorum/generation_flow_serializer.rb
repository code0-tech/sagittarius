# frozen_string_literal: true

module Velorum
  class GenerationFlowSerializer
    def initialize(flow)
      @flow = flow
    end

    def to_h
      {
        name: flow.name,
        type: flow.type,
        starting_node_id: blank_zero(flow.starting_node_id),
        settings: flow.settings.map { |setting| flow_setting_to_h(setting) },
        nodes: flow.node_functions.map { |node| node_to_h(node) },
      }
    end

    private

    attr_reader :flow

    def node_to_h(node)
      {
        id: blank_zero(node.database_id),
        function_identifier: node.runtime_function_id,
        next_node_id: blank_zero(node.next_node_id),
        definition_source: node.definition_source,
        parameters: node.parameters.map { |parameter| parameter_to_h(parameter) },
      }
    end

    def parameter_to_h(parameter)
      {
        id: blank_zero(parameter.database_id),
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
        hash[:node_function_id] = blank_zero(value.input_type.node_id)
        hash[:parameter_index] = blank_zero(value.input_type.parameter_index)
        hash[:input_index] = blank_zero(value.input_type.input_index)
      elsif !value.flow_input
        hash[:node_function_id] = blank_zero(value.node_id)
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
        starting_node_id: blank_zero(sub_flow.starting_node_id),
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

    def flow_setting_to_h(setting)
      {
        id: blank_zero(setting.database_id),
        flow_setting_id: setting.flow_setting_id,
        value: setting.value&.to_ruby(true),
        cast: setting.cast,
      }
    end

    def blank_zero(value)
      return if value.blank? || value.to_s == '0'

      value
    end
  end
end
