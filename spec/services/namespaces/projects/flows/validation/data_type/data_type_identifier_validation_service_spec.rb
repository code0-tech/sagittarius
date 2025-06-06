# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::Validation::DataType::DataTypeIdentifierValidationService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), flow, node, data_type_identifier).execute
  end

  include_context 'with mocked services'

  let(:all_service_expectations) do
    # Default case
    {
      Namespaces::Projects::Flows::Validation::DataType::DataTypeValidationService => 0,
      Namespaces::Projects::Flows::Validation::NodeFunction::GenericTypeValidationService => 0,
    }
  end
  let(:mocked_service_expectations) { all_service_expectations }

  let(:current_user) { create(:user) }
  let(:runtime) { create(:runtime) }
  let(:namespace_project) { create(:namespace_project, primary_runtime: runtime) }
  let(:node) do
    create(:node_function,
           runtime_function: create(:runtime_function_definition, generic_keys: ['T'], runtime: runtime))
  end
  let(:parameter) do
    create(
      :node_parameter,
      runtime_parameter: create(:runtime_parameter_definition, data_type: data_type_identifier),
      node_function: node
    )
  end
  let(:flow) { create(:flow, project: namespace_project) }
  let(:data_type_identifier) { create(:data_type_identifier, generic_key: 'T', runtime: runtime) }

  let(:generic_mapper) do
    create(:generic_mapper, source:
    create(:data_type_identifier, data_type: create(:data_type, runtime: runtime)), target: 'T')
  end

  context 'when data_type.runtime == runtime' do
    it { expect(service_response).to be_nil }
  end

  context 'when data_type.runtime != runtime' do
    let(:data_type_identifier) { create(:data_type_identifier, data_type: create(:data_type)) }

    it 'returns an error' do
      expect(service_response).to be_error
      expect(service_response.payload).to eq(:runtime_mismatch)
    end
  end

  context 'when data_type_identifier is a data_type' do
    let(:data_type_identifier) do
      create(:data_type_identifier, data_type: create(:data_type, runtime: runtime), runtime: runtime)
    end

    let(:mocked_service_expectations) do
      {
        **all_service_expectations,
        Namespaces::Projects::Flows::Validation::DataType::DataTypeValidationService => 1,
      }
    end

    it { expect(service_response).to be_nil }
  end

  context 'when T is contained in the function definition' do
    let(:node) do
      create(:node_function,
             runtime_function: create(:runtime_function_definition, generic_keys: ['T'], runtime: runtime))
    end

    it { expect(service_response).to be_nil }
  end

  context 'when T is not contained in the function definition' do
    let(:node) do
      create(:node_function,
             runtime_function: create(:runtime_function_definition, generic_keys: [], runtime: runtime))
    end

    it { expect(service_response).to be_error }
    it { expect(service_response.payload).to eq(:generic_key_not_found) }
  end
end
