# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::Validation::DataType::GenericDataTypeIdentifierValidationService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), flow, data_type_identifier).execute
  end

  include_context 'with mocked services'

  let(:all_service_expectations) do
    # Default case
    {
      Namespaces::Projects::Flows::Validation::DataType::DataTypeValidationService => 1,
    }
  end
  let(:current_user) { create(:user) }
  let(:runtime) { create(:runtime) }
  let(:namespace_project) { create(:namespace_project).tap { |np| np.primary_runtime = runtime } }
  let(:flow) { create(:flow, project: namespace_project) }
  let(:data_type_identifier) { create(:data_type_identifier, data_type: create(:data_type), runtime: runtime) }
  let(:mocked_service_expectations) { all_service_expectations }
  let(:default_execute_response) { nil }

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

  context 'when data_type_identifier is not a data_type' do
    let(:data_type_identifier) { create(:data_type_identifier, generic_key: 'T', runtime: runtime) }

    let(:mocked_service_expectations) do
      {
        **all_service_expectations,
        Namespaces::Projects::Flows::Validation::DataType::DataTypeValidationService => 0,
      }
    end

    it { expect(service_response).to be_nil }
  end
end
