# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::Validation::DataType::DataTypeIdentifierValidationService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), flow, node, data_type_identifier).execute
  end

  let(:current_user) { create(:user) }
  let(:runtime) { create(:runtime) }
  let(:namespace_project) { create(:namespace_project, primary_runtime: runtime) }
  let(:node) do
    create(
      :node_function,
      function_definition: create(
        :function_definition,
        runtime_function_definition: create(
          :runtime_function_definition,
          generic_keys: ['T'],
          runtime: runtime
        )
      )
    )
  end
  let(:parameter) do
    create(
      :node_parameter,
      parameter_definition: create(
        :parameter_definition,
        runtime_parameter_definition: create(
          :runtime_parameter_definition,
          data_type: data_type_identifier
        )
      ),
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
    it { expect(service_response).to be_empty }
  end

  context 'when data_type.runtime != runtime' do
    let(:data_type_identifier) { create(:data_type_identifier, data_type: create(:data_type)) }

    it 'returns an error' do
      expect(service_response).to include(have_attributes(error_code: :data_type_runtime_mismatch))
    end
  end

  context 'when data_type_identifier is a data_type' do
    let(:data_type_identifier) do
      create(:data_type_identifier, data_type: create(:data_type, runtime: runtime), runtime: runtime)
    end

    it { expect(service_response).to be_empty }
  end

  context 'when T is contained in the function definition' do
    let(:node) do
      create(
        :node_function,
        function_definition: create(
          :function_definition,
          runtime_function_definition: create(
            :runtime_function_definition,
            generic_keys: ['T'],
            runtime: runtime
          )
        )
      )
    end

    it { expect(service_response).to be_empty }
  end

  context 'when T is not contained in the function definition' do
    let(:node) do
      create(
        :node_function,
        function_definition: create(
          :function_definition,
          runtime_function_definition: create(
            :runtime_function_definition,
            generic_keys: [],
            runtime: runtime
          )
        )
      )
    end

    it { expect(service_response).to include(have_attributes(error_code: :data_type_identifier_generic_key_not_found)) }
  end
end
