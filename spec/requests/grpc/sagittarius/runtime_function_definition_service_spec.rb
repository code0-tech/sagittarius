# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sagittarius.RuntimeFunctionDefinitionService', :need_grpc_server do
  include GrpcHelpers

  let(:stub) { create_stub Tucana::Sagittarius::RuntimeFunctionDefinitionService }

  describe 'Update' do
    context 'when create' do
      let(:namespace) { create(:namespace) }
      let(:runtime) { create(:runtime, namespace: namespace) }
      let(:parameter_type) { create(:data_type, namespace: namespace) }
      let(:return_type) { create(:data_type, namespace: namespace) }

      let(:runtime_functions) do
        [
          {
            runtime_name: 'runtime_function_id',
            name: [
              { code: 'de_DE', content: 'Eine Funktion' }
            ],
            return_type_identifier: return_type.identifier,
            runtime_parameter_definitions: [
              data_type_identifier: parameter_type.identifier,
              runtime_name: 'runtime_parameter_definition_id',
              name: [
                { code: 'de_DE', content: 'Ein Parameter' }
              ]
            ],
          }
        ]
      end

      let(:message) do
        Tucana::Sagittarius::RuntimeFunctionDefinitionUpdateRequest.new(runtime_functions: runtime_functions)
      end

      it 'creates a correct functions' do
        expect(stub.update(message, authorization(runtime)).success).to be(true)

        function = RuntimeFunctionDefinition.last
        expect(function.runtime_name).to eq('runtime_function_id')
        expect(function.return_type.identifier).to eq(return_type.identifier)
        expect(function.names.first.content).to eq('Eine Funktion')
        parameter = function.parameters.first
        expect(parameter.data_type.identifier).to eq(parameter_type.identifier)
        expect(parameter.runtime_name).to eq('runtime_parameter_definition_id')
        expect(parameter.names.first.content).to eq('Ein Parameter')

        function_definition = FunctionDefinition.first
        expect(function_definition.names.first.content).to eq('Eine Funktion')
        expect(function_definition.return_type.identifier).to eq(return_type.identifier)
        parameter = ParameterDefinition.first
        expect(parameter.data_type.identifier).to eq(parameter_type.identifier)
        expect(parameter.names.first.content).to eq('Ein Parameter')
      end
    end

    context 'when update' do
      let(:namespace) { create(:namespace) }
      let(:runtime) { create(:runtime, namespace: namespace) }
      let(:data_type) { create(:data_type, namespace: namespace) }

      let(:existing_runtime_function_definition) do
        create(:runtime_function_definition,
               namespace: namespace,
               runtime_name: 'runtime_function_id',
               names: create(:translation, code: 'en_US', content: 'A Function'))
      end

      let(:runtime_functions) do
        [
          {
            runtime_name: 'runtime_function_id',
            name: [
              { code: 'de_DE', content: 'Eine Funktion' }
            ],
            runtime_parameter_definitions: [
              data_type_identifier: data_type.identifier,
              runtime_name: 'runtime_parameter_definition_id',
              name: [
                { code: 'de_DE', content: 'Ein Parameter' }
              ]
            ],
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
        expect(function.runtime_name).to eq('runtime_function_id')
        expect(function.names.first.content).to eq('Eine Funktion')
        parameter = function.parameters.first
        expect(parameter.data_type.identifier).to eq(data_type.identifier)
        expect(parameter.runtime_name).to eq('runtime_parameter_definition_id')
        expect(parameter.names.first.content).to eq('Ein Parameter')

        expect(FunctionDefinition.count).to eq(1)
        expect(ParameterDefinition.count).to eq(1)
      end
    end
  end
end
