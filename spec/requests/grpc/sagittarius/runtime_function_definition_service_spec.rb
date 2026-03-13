# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sagittarius.RuntimeFunctionDefinitionService', :need_grpc_server do
  include GrpcHelpers

  let(:stub) { create_stub Tucana::Sagittarius::RuntimeFunctionDefinitionService }

  describe 'Update' do
    context 'when create' do
      let(:runtime) { create(:runtime) }
      let!(:list_data_type) { create(:data_type, identifier: 'LIST', runtime: runtime) }
      let!(:predicate_data_type) { create(:data_type, identifier: 'PREDICATE', runtime: runtime) }

      let(:runtime_functions) do
        [
          {
            runtime_name: 'std::list::filter',
            signature: '<T>(list: LIST<T>, predicate: PREDICATE<T>): LIST<T>',
            name: [
              { code: 'en_US', content: 'Filter List' }
            ],
            description: [
              { code: 'en_US', content: 'Filters a list by a predicate' }
            ],
            documentation: [
              { code: 'en_US', content: 'Filter documentation' }
            ],
            deprecation_message: [
              { code: 'en_US', content: 'Use filter_v2 instead' }
            ],
            display_message: [
              { code: 'en_US', content: 'Filter elements in ${list} matching ${predicate}' }
            ],
            alias: [
              { code: 'en_US', content: 'filter;array;list' }
            ],
            throws_error: false,
            linked_data_type_identifiers: %w[LIST PREDICATE],
            runtime_parameter_definitions: [
              {
                runtime_name: 'list',
                default_value: nil,
                name: [
                  { code: 'en_US', content: 'Input List' }
                ],
                description: [
                  { code: 'en_US', content: 'The list to be filtered' }
                ],
                documentation: [
                  { code: 'en_US', content: 'List documentation' }
                ],
              },
              {
                runtime_name: 'predicate',
                default_value: Tucana::Shared::Value.from_ruby({ 'key' => 'value' }),
                name: [
                  { code: 'en_US', content: 'Filter Predicate' }
                ],
                description: [
                  { code: 'en_US', content: 'A function that returns a boolean' }
                ],
                documentation: [],
              }
            ],
            version: '0.0.0',
          }
        ]
      end

      let(:message) do
        Tucana::Sagittarius::RuntimeFunctionDefinitionUpdateRequest.new(runtime_functions: runtime_functions)
      end

      it 'creates a correct functions' do
        expect(stub.update(message, authorization(runtime)).success).to be(true)

        function = RuntimeFunctionDefinition.last
        expect(function.runtime_name).to eq('std::list::filter')
        expect(function.signature).to eq('<T>(list: LIST<T>, predicate: PREDICATE<T>): LIST<T>')
        expect(function.names.first.content).to eq('Filter List')
        expect(function.descriptions.first.content).to eq('Filters a list by a predicate')
        expect(function.documentations.first.content).to eq('Filter documentation')
        expect(function.deprecation_messages.first.content).to eq('Use filter_v2 instead')
        expect(function.aliases.first.content).to eq('filter;array;list')
        expect(function.display_messages.first.content).to eq('Filter elements in ${list} matching ${predicate}')
        expect(function.throws_error).to be(false)
        expect(function.version).to eq('0.0.0')
        expect(function.referenced_data_types).to contain_exactly(list_data_type, predicate_data_type)

        expect(function.parameters.count).to eq(2)
        list_param = function.parameters.find_by(runtime_name: 'list')
        expect(list_param.names.first.content).to eq('Input List')
        expect(list_param.descriptions.first.content).to eq('The list to be filtered')
        expect(list_param.documentations.first.content).to eq('List documentation')
        expect(list_param.default_value).to be_nil

        predicate_param = function.parameters.find_by(runtime_name: 'predicate')
        expect(predicate_param.names.first.content).to eq('Filter Predicate')
        expect(predicate_param.default_value).to eq({ 'key' => 'value' })

        function_definition = FunctionDefinition.first
        expect(function_definition.names.first.content).to eq('Filter List')
        expect(function_definition.descriptions.first.content).to eq('Filters a list by a predicate')
        expect(function_definition.documentations.first.content).to eq('Filter documentation')
        expect(function_definition.aliases.first.content).to eq('filter;array;list')
        expect(function_definition.display_messages.first.content).to eq(
          'Filter elements in ${list} matching ${predicate}'
        )

        expect(ParameterDefinition.count).to eq(2)
        list_param_def = ParameterDefinition.find_by(runtime_parameter_definition: list_param)
        expect(list_param_def.names.first.content).to eq('Input List')
        expect(list_param_def.descriptions.first.content).to eq('The list to be filtered')
        expect(list_param_def.documentations.first.content).to eq('List documentation')
        expect(list_param_def.default_value).to be_nil
      end
    end

    context 'when update' do
      let(:runtime) { create(:runtime) }
      let(:list_data_type) { create(:data_type, identifier: 'LIST', runtime: runtime) }

      let(:existing_runtime_function_definition) do
        create(:runtime_function_definition,
               runtime: runtime,
               runtime_name: 'std::list::filter',
               names: create(:translation, code: 'en_US', content: 'Filter List'))
      end

      let(:runtime_functions) do
        [
          {
            runtime_name: 'std::list::filter',
            signature: '<T>(list: LIST<T>): LIST<T>',
            name: [
              { code: 'de_DE', content: 'Liste filtern' }
            ],
            runtime_parameter_definitions: [
              {
                runtime_name: 'list',
                name: [
                  { code: 'de_DE', content: 'Eingabeliste' }
                ],
              }
            ],
            linked_data_type_identifiers: [list_data_type.identifier],
            version: '0.0.0',
          }
        ]
      end

      let(:message) do
        Tucana::Sagittarius::RuntimeFunctionDefinitionUpdateRequest.new(runtime_functions: runtime_functions)
      end

      it 'creates a correct functions' do
        expect(stub.update(message, authorization(runtime)).success).to be(true)

        expect(RuntimeFunctionDefinition.count).to eq(1)

        function = RuntimeFunctionDefinition.last
        expect(function.runtime_name).to eq('std::list::filter')
        expect(function.signature).to eq('<T>(list: LIST<T>): LIST<T>')
        expect(function.names.first.content).to eq('Liste filtern')
        parameter = function.parameters.first
        expect(parameter.runtime_name).to eq('list')
        expect(parameter.names.first.content).to eq('Eingabeliste')

        expect(FunctionDefinition.count).to eq(1)
        expect(ParameterDefinition.count).to eq(1)
      end
    end

    context 'when deleting' do
      let(:runtime) { create(:runtime) }

      let!(:existing_runtime_function_definition) do
        create(:runtime_function_definition, runtime: runtime)
      end

      let!(:existing_runtime_parameter_definition) do
        create(:runtime_parameter_definition,
               runtime_function_definition: existing_runtime_function_definition)
      end

      let(:message) do
        Tucana::Sagittarius::RuntimeFunctionDefinitionUpdateRequest.new(runtime_functions: runtime_functions)
      end

      describe 'parameter definitions' do
        let(:runtime_functions) do
          [
            {
              runtime_name: existing_runtime_function_definition.runtime_name,
              signature: '() => void',
              name: [
                { code: 'de_DE', content: 'Eine Funktion' }
              ],
              runtime_parameter_definitions: [],
              linked_data_type_identifiers: [],
              version: '0.0.0',
            }
          ]
        end

        it 'marks them as removed' do
          expect(stub.update(message, authorization(runtime)).success).to be(true)

          expect(existing_runtime_function_definition.reload.removed_at).not_to be_present
          expect(existing_runtime_parameter_definition.reload.removed_at).to be_present
        end
      end

      describe 'function definitions' do
        let(:runtime_functions) do
          []
        end

        it 'marks them as removed' do
          expect(stub.update(message, authorization(runtime)).success).to be(true)

          expect(existing_runtime_function_definition.reload.removed_at).to be_present
        end
      end
    end
  end
end
