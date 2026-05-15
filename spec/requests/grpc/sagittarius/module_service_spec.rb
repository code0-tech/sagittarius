# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sagittarius.ModuleService', :need_grpc_server do
  include GrpcHelpers

  let(:stub) { create_stub Tucana::Sagittarius::ModuleService }
  let(:runtime) { create(:runtime) }

  describe 'Update' do
    let(:modules) do
      [
        {
          identifier: 'taurus',
          name: [{ code: 'en_US', content: 'Taurus' }],
          description: [{ code: 'en_US', content: 'Core module' }],
          documentation: 'Module documentation',
          author: 'Code0',
          icon: 'taurus-icon',
          version: '1.2.3',
          definition_data_types: [
            {
              identifier: 'TEXT',
              type: 'string',
              linked_data_type_identifiers: [],
              version: '1.2.3',
              definition_source: 'taurus',
            },
            {
              identifier: 'TEXT_LIST',
              type: 'TEXT[]',
              linked_data_type_identifiers: ['TEXT'],
              version: '1.2.3',
              definition_source: 'taurus',
            }
          ],
          runtime_flow_types: [
            {
              identifier: 'RUNTIME_FORM',
              signature: '(input: TEXT): TEXT_LIST',
              linked_data_type_identifiers: %w[TEXT TEXT_LIST],
              runtime_settings: [
                {
                  identifier: 'title',
                  unique: :PROJECT,
                  default_value: Tucana::Shared::Value.from_ruby('Untitled'),
                }
              ],
              editable: false,
              version: '1.2.3',
              definition_source: 'taurus',
              display_icon: 'form-icon',
            }
          ],
          flow_types: [
            {
              identifier: 'FORM',
              runtime_identifier: 'RUNTIME_FORM',
              settings: [
                {
                  identifier: 'title',
                  unique: :PROJECT,
                  default_value: Tucana::Shared::Value.from_ruby('Untitled'),
                }
              ],
              signature: '(input: TEXT): TEXT_LIST',
              linked_data_type_identifiers: %w[TEXT TEXT_LIST],
              editable: false,
              version: '1.2.3',
              definition_source: 'taurus',
              display_icon: 'form-icon',
            }
          ],
          runtime_function_definitions: [
            {
              runtime_name: 'std::text::split',
              signature: '(text: TEXT): TEXT_LIST',
              linked_data_type_identifiers: %w[TEXT TEXT_LIST],
              runtime_parameter_definitions: [
                {
                  runtime_name: 'text',
                  name: [{ code: 'en_US', content: 'Text' }],
                }
              ],
              version: '1.2.3',
              definition_source: 'taurus',
              display_icon: 'split-icon',
            }
          ],
          function_definitions: [
            {
              runtime_definition_name: 'std::text::split',
              parameter_definitions: [
                {
                  runtime_name: 'text',
                  default_value: Tucana::Shared::Value.from_ruby('hello'),
                  name: [{ code: 'en_US', content: 'Visible Text' }],
                }
              ],
              name: [{ code: 'en_US', content: 'Split text' }],
            }
          ],
          configurations: [
            {
              identifier: 'api_key',
              name: [{ code: 'en_US', content: 'API key' }],
              type: 'TEXT',
              linked_data_type_identifiers: ['TEXT'],
              default_value: Tucana::Shared::Value.from_ruby('secret'),
              optional: true,
              hidden: true,
            }
          ],
        }
      ]
    end

    let(:message) { Tucana::Sagittarius::ModuleUpdateRequest.new(modules: modules) }

    it 'creates the module and its nested definitions' do
      expect(stub.update(message, authorization(runtime)).success).to be(true)

      runtime_module = RuntimeModule.find_by!(runtime: runtime, identifier: 'taurus')
      expect(runtime_module).to have_attributes(
        documentation: 'Module documentation',
        author: 'Code0',
        icon: 'taurus-icon',
        version: '1.2.3'
      )
      expect(runtime_module.names.first.content).to eq('Taurus')
      expect(runtime_module.descriptions.first.content).to eq('Core module')

      text = DataType.find_by!(runtime: runtime, identifier: 'TEXT')
      text_list = DataType.find_by!(runtime: runtime, identifier: 'TEXT_LIST')
      expect(text.runtime_module).to eq(runtime_module)
      expect(text_list.runtime_module).to eq(runtime_module)
      expect(text_list.referenced_data_types).to contain_exactly(text)

      runtime_flow_type = RuntimeFlowType.find_by!(runtime: runtime, identifier: 'RUNTIME_FORM')
      expect(runtime_flow_type.runtime_module).to eq(runtime_module)
      expect(runtime_flow_type.runtime_flow_type_settings.first.identifier).to eq('title')
      expect(runtime_flow_type.referenced_data_types).to contain_exactly(text, text_list)

      flow_type = FlowType.find_by!(runtime: runtime, identifier: 'FORM')
      expect(flow_type.runtime_module).to eq(runtime_module)
      expect(flow_type.runtime_flow_type).to eq(runtime_flow_type)
      expect(flow_type.referenced_data_types).to contain_exactly(text, text_list)

      runtime_function = RuntimeFunctionDefinition.find_by!(runtime: runtime, runtime_name: 'std::text::split')
      expect(runtime_function.runtime_module).to eq(runtime_module)
      expect(runtime_function.referenced_data_types).to contain_exactly(text, text_list)
      expect(runtime_function.parameters.first.runtime_name).to eq('text')

      function_definition = runtime_function.function_definitions.first
      expect(function_definition.names.first.content).to eq('Split text')
      expect(function_definition.parameter_definitions.first.default_value).to eq('hello')
      expect(function_definition.parameter_definitions.first.names.first.content).to eq('Visible Text')

      configuration = runtime_module.module_configuration_definitions.find_by!(identifier: 'api_key')
      expect(configuration).to have_attributes(type: 'TEXT', default_value: 'secret', optional: true, hidden: true)
      expect(configuration.names.first.content).to eq('API key')
      expect(configuration.referenced_data_types).to contain_exactly(text)
    end

    context 'when data types reference data types from another module' do
      let(:modules) do
        [
          {
            identifier: 'module-a',
            version: '1.0.0',
            definition_data_types: [
              {
                identifier: 'A_TYPE',
                type: 'B_TYPE',
                linked_data_type_identifiers: ['B_TYPE'],
                version: '1.0.0',
                definition_source: 'module-a',
              }
            ],
            runtime_flow_types: [],
            flow_types: [],
            runtime_function_definitions: [],
            function_definitions: [],
            configurations: [],
          },
          {
            identifier: 'module-b',
            version: '1.0.0',
            definition_data_types: [
              {
                identifier: 'B_TYPE',
                type: 'A_TYPE',
                linked_data_type_identifiers: ['A_TYPE'],
                version: '1.0.0',
                definition_source: 'module-b',
              }
            ],
            runtime_flow_types: [],
            flow_types: [],
            runtime_function_definitions: [],
            function_definitions: [],
            configurations: [],
          }
        ]
      end

      it 'creates all data types before linking them' do
        expect(stub.update(message, authorization(runtime)).success).to be(true)

        module_a = RuntimeModule.find_by!(runtime: runtime, identifier: 'module-a')
        module_b = RuntimeModule.find_by!(runtime: runtime, identifier: 'module-b')
        a_type = DataType.find_by!(runtime: runtime, identifier: 'A_TYPE')
        b_type = DataType.find_by!(runtime: runtime, identifier: 'B_TYPE')

        expect(a_type.runtime_module).to eq(module_a)
        expect(b_type.runtime_module).to eq(module_b)
        expect(a_type.referenced_data_types).to contain_exactly(b_type)
        expect(b_type.referenced_data_types).to contain_exactly(a_type)
      end
    end

    context 'when a definition is not sent anymore' do
      let!(:runtime_module) { create(:runtime_module, runtime: runtime, identifier: 'taurus') }
      let!(:data_type) { create(:data_type, runtime: runtime, runtime_module: runtime_module) }
      let(:modules) do
        [
          {
            identifier: 'taurus',
            version: '1.2.3',
            definition_data_types: [],
            runtime_flow_types: [],
            flow_types: [],
            runtime_function_definitions: [],
            function_definitions: [],
            configurations: [],
          }
        ]
      end

      it 'marks the existing definition as removed' do
        expect(stub.update(message, authorization(runtime)).success).to be(true)

        expect(data_type.reload.removed_at).to be_present
      end
    end
  end
end
