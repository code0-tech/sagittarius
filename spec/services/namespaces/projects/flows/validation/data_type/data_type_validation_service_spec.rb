require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::Validation::DataType::DataTypeValidationService do
  include_context 'mocked service class instances'

  let(:all_service_expectations) do
    # Default case
    {
      Namespaces::Projects::Flows::Validation::DataType::DataTypeRuleValidationService => 0,
    }
  end

  let(:default_execute_response) { ServiceResponse.success(payload: default_payload) }

  let(:mocked_service_expectations) { all_service_expectations }

  subject(:service_response) { described_class.new(create_authentication(current_user), flow, data_type).execute }

  let(:current_user) { create(:user) }
  let(:runtime) { create(:runtime) }
  let(:namespace_project) { create(:namespace_project).tap { |np| np.primary_runtime = runtime } }

  let(:flow) { create(:flow, project: namespace_project) }
  let(:data_type) { create(:data_type, runtime: runtime) }

  context 'when data_type.runtime == runtime' do
    it { expect(service_response).to eq(nil) }
  end

  context 'when data_type.runtime != runtime' do
    let(:data_type) { create(:data_type) }


    it 'returns an error' do
      expect(service_response).to be_error
      expect(service_response.payload).to eq(:runtime_mismatch)
    end
  end

  context 'when rules are set' do
    let(:data_type) { create(:data_type, runtime: runtime, rules: [create(:data_type_rule)]) }

    let(:mocked_service_expectations) do
      {
        **all_service_expectations,
        Namespaces::Projects::Flows::Validation::DataType::DataTypeRuleValidationService => 1,
      }
    end

    it { expect(service_response).to eq(nil) }
  end

  context 'when parent type is set' do
    let(:parent_data_type) { create(:data_type, runtime: runtime) }
    let(:data_type) { create(:data_type, runtime: runtime, parent_type: parent_data_type) }

    it { expect(service_response).to eq(nil) }
  end

  context 'when parent type is set and invalid' do
    let(:parent_data_type) { create(:data_type) }
    let(:data_type) { create(:data_type, runtime: runtime, parent_type: parent_data_type) }

    it { expect(service_response.payload).to eq(:runtime_mismatch) }
  end


end
