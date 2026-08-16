# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sagittarius_rails.ModuleService ordered definitions', :need_grpc_server do
  include GrpcHelpers

  let(:stub) { create_stub Tucana::Sagittarius::Rails::ModuleService }
  let(:runtime) { create(:runtime) }

  describe 'ordering after parameter/setting reorder' do
    let(:initial_modules) do
      [
        {
          identifier: 'ordering-test',
          version: '1.0.0',
          definition_data_types: [],
          runtime_flow_types: [
            {
              identifier: 'RUNTIME_ORDERED_FLOW',
              signature: '(): void',
              editable: false,
              version: '1.0.0',
              definition_source: 'ordering-test',
              runtime_settings: [
                {
                  identifier: 'setting_a',
                  unique: :NONE,
                  optional: false,
                  hidden: false,
                },
                {
                  identifier: 'setting_b',
                  unique: :NONE,
                  optional: false,
                  hidden: false,
                },
                {
                  identifier: 'setting_c',
                  unique: :NONE,
                  optional: false,
                  hidden: false,
                }
              ],
            }
          ],
          flow_types: [
            {
              identifier: 'ORDERED_FLOW',
              runtime_identifier: 'RUNTIME_ORDERED_FLOW',
              signature: '(): void',
              editable: false,
              version: '1.0.0',
              definition_source: 'ordering-test',
              settings: [
                {
                  identifier: 'setting_a',
                  unique: :NONE,
                  optional: false,
                  hidden: false,
                },
                {
                  identifier: 'setting_b',
                  unique: :NONE,
                  optional: false,
                  hidden: false,
                },
                {
                  identifier: 'setting_c',
                  unique: :NONE,
                  optional: false,
                  hidden: false,
                }
              ],
            }
          ],
          runtime_function_definitions: [
            {
              runtime_name: 'ordering::func',
              signature: '(a, b, c): void',
              version: '1.0.0',
              definition_source: 'ordering-test',
              runtime_parameter_definitions: [
                {
                  runtime_name: 'param_a',
                  optional: false,
                  hidden: false,
                },
                {
                  runtime_name: 'param_b',
                  optional: false,
                  hidden: false,
                },
                {
                  runtime_name: 'param_c',
                  optional: false,
                  hidden: false,
                }
              ],
            }
          ],
          function_definitions: [
            {
              runtime_name: 'ordering::func_visible',
              runtime_definition_name: 'ordering::func',
              parameter_definitions: [
                {
                  runtime_name: 'param_a',
                  optional: false,
                  hidden: false,
                },
                {
                  runtime_name: 'param_b',
                  optional: false,
                  hidden: false,
                },
                {
                  runtime_name: 'param_c',
                  optional: false,
                  hidden: false,
                }
              ],
            }
          ],
          configurations: [],
        }
      ]
    end

    let(:reordered_modules) do
      [
        {
          identifier: 'ordering-test',
          version: '1.0.1',
          definition_data_types: [],
          runtime_flow_types: [
            {
              identifier: 'RUNTIME_ORDERED_FLOW',
              signature: '(): void',
              editable: false,
              version: '1.0.1',
              definition_source: 'ordering-test',
              runtime_settings: [
                {
                  identifier: 'setting_c',
                  unique: :NONE,
                  optional: false,
                  hidden: false,
                },
                {
                  identifier: 'setting_a',
                  unique: :NONE,
                  optional: false,
                  hidden: false,
                },
                {
                  identifier: 'setting_b',
                  unique: :NONE,
                  optional: false,
                  hidden: false,
                }
              ],
            }
          ],
          flow_types: [
            {
              identifier: 'ORDERED_FLOW',
              runtime_identifier: 'RUNTIME_ORDERED_FLOW',
              signature: '(): void',
              editable: false,
              version: '1.0.1',
              definition_source: 'ordering-test',
              settings: [
                {
                  identifier: 'setting_c',
                  unique: :NONE,
                  optional: false,
                  hidden: false,
                },
                {
                  identifier: 'setting_a',
                  unique: :NONE,
                  optional: false,
                  hidden: false,
                },
                {
                  identifier: 'setting_b',
                  unique: :NONE,
                  optional: false,
                  hidden: false,
                }
              ],
            }
          ],
          runtime_function_definitions: [
            {
              runtime_name: 'ordering::func',
              signature: '(c, a, b): void',
              version: '1.0.1',
              definition_source: 'ordering-test',
              runtime_parameter_definitions: [
                {
                  runtime_name: 'param_c',
                  optional: false,
                  hidden: false,
                },
                {
                  runtime_name: 'param_a',
                  optional: false,
                  hidden: false,
                },
                {
                  runtime_name: 'param_b',
                  optional: false,
                  hidden: false,
                }
              ],
            }
          ],
          function_definitions: [
            {
              runtime_name: 'ordering::func_visible',
              runtime_definition_name: 'ordering::func',
              parameter_definitions: [
                {
                  runtime_name: 'param_c',
                  optional: false,
                  hidden: false,
                },
                {
                  runtime_name: 'param_a',
                  optional: false,
                  hidden: false,
                },
                {
                  runtime_name: 'param_b',
                  optional: false,
                  hidden: false,
                }
              ],
            }
          ],
          configurations: [],
        }
      ]
    end

    it 'returns parameters and settings in the order they were last sent' do
      # Initial creation with order: a, b, c
      initial_message = Tucana::Sagittarius::Rails::ModuleUpdateRequest.new(modules: initial_modules)
      response = stub.update(initial_message, authorization(runtime))
      expect(response.success).to be(true)

      # Set up flow and node_function referencing the created definitions
      function_definition = FunctionDefinition.find_by!(runtime: runtime, identifier: 'ordering::func_visible')
      flow_type = FlowType.find_by!(runtime: runtime, identifier: 'ORDERED_FLOW')
      runtime_function = RuntimeFunctionDefinition.find_by!(runtime: runtime, runtime_name: 'ordering::func')
      runtime_flow_type = RuntimeFlowType.find_by!(runtime: runtime, identifier: 'RUNTIME_ORDERED_FLOW')

      param_a = runtime_function.parameters.find_by!(runtime_name: 'param_a')
      param_b = runtime_function.parameters.find_by!(runtime_name: 'param_b')
      param_c = runtime_function.parameters.find_by!(runtime_name: 'param_c')

      rft_setting_a = runtime_flow_type.runtime_flow_type_settings.find_by!(identifier: 'setting_a')
      rft_setting_b = runtime_flow_type.runtime_flow_type_settings.find_by!(identifier: 'setting_b')
      rft_setting_c = runtime_flow_type.runtime_flow_type_settings.find_by!(identifier: 'setting_c')

      project = create(:namespace_project)
      flow = create(:flow, project: project, flow_type: flow_type)
      node_function = create(:node_function, flow: flow, function_definition: function_definition)

      # Create node parameters (insertion order doesn't matter, ordering comes from definitions)
      node_param_a = create(
        :node_parameter,
        node_function: node_function,
        parameter_definition: function_definition.parameter_definitions.find_by!(runtime_parameter_definition: param_a)
      )
      node_param_b = create(
        :node_parameter,
        node_function: node_function,
        parameter_definition: function_definition.parameter_definitions.find_by!(runtime_parameter_definition: param_b)
      )
      node_param_c = create(
        :node_parameter,
        node_function: node_function,
        parameter_definition: function_definition.parameter_definitions.find_by!(runtime_parameter_definition: param_c)
      )

      # Create flow settings (insertion order doesn't matter, ordering comes from definitions)
      fts_a = flow_type.flow_type_settings.find_by!(runtime_flow_type_setting: rft_setting_a)
      fts_b = flow_type.flow_type_settings.find_by!(runtime_flow_type_setting: rft_setting_b)
      fts_c = flow_type.flow_type_settings.find_by!(runtime_flow_type_setting: rft_setting_c)

      flow_setting_a = create(:flow_setting, flow: flow, flow_setting_id: fts_a.identifier)
      flow_setting_b = create(:flow_setting, flow: flow, flow_setting_id: fts_b.identifier)
      flow_setting_c = create(:flow_setting, flow: flow, flow_setting_id: fts_c.identifier)

      # After initial update, order should be a, b, c
      expect(node_function.ordered_parameters.to_a).to eq([node_param_a, node_param_b, node_param_c])
      expect(flow.ordered_settings.to_a).to eq([flow_setting_a, flow_setting_b, flow_setting_c])

      # Send update with reordered definitions: c, a, b
      reordered_message = Tucana::Sagittarius::Rails::ModuleUpdateRequest.new(modules: reordered_modules)
      response = stub.update(reordered_message, authorization(runtime))
      expect(response.success).to be(true)

      # After reorder, ordered_parameters should reflect the new order: c, a, b
      expect(node_function.ordered_parameters.to_a).to eq([node_param_c, node_param_a, node_param_b])

      # After reorder, ordered_settings should reflect the new order: c, a, b
      expect(flow.ordered_settings.to_a).to eq([flow_setting_c, flow_setting_a, flow_setting_b])
    end
  end
end
