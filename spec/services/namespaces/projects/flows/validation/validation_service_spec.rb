# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::Validation::ValidationService do
  subject(:service_response) { described_class.new(create_authentication(current_user), flow).execute }

  include_context 'with mocked services'

  let(:all_service_expectations) do
    # Default case
    {
      Namespaces::Projects::Flows::Validation::DataType::DataTypeValidationService => 0,
      Namespaces::Projects::Flows::Validation::FlowSettingValidationService => 0,
      Namespaces::Projects::Flows::Validation::NodeFunction::NodeFunctionValidationService => 1,
      Namespaces::Projects::Flows::Validation::FlowTypeValidationService => 1,
    }
  end
  let(:mocked_service_expectations) { all_service_expectations }

  let(:default_payload) { flow }

  let(:current_user) { create(:user) }
  let(:runtime) { create(:runtime) }
  let(:namespace_project) { create(:namespace_project).tap { |np| np.primary_runtime = runtime } }
  let(:flow) { create(:flow, project: namespace_project) }

  context 'when primary runtime is set and return and input and settings empty' do
    it { is_expected.to be_success }
    it { expect(service_response.payload).to eq(flow) }
  end

  context 'when input type is set' do
    before do
      flow.update!(input_type: create(:data_type))
    end

    let(:mocked_service_expectations) do
      {
        **all_service_expectations,
        Namespaces::Projects::Flows::Validation::DataType::DataTypeValidationService => 1,
      }
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload).to eq(flow) }
  end

  context 'when return type is set' do
    before do
      flow.update!(return_type: create(:data_type))
    end

    let(:mocked_service_expectations) do
      {
        **all_service_expectations,
        Namespaces::Projects::Flows::Validation::DataType::DataTypeValidationService => 1,
      }
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload).to eq(flow) }
  end

  context 'when return type and input type is set' do
    before do
      flow.update!(return_type: create(:data_type), input_type: create(:data_type))
    end

    let(:mocked_service_expectations) do
      {
        **all_service_expectations,
        Namespaces::Projects::Flows::Validation::DataType::DataTypeValidationService => 2,
      }
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload).to eq(flow) }
  end

  context 'when flow settings are set' do
    let(:amount_of_flow_settings) { SecureRandom.random_number(5) + 1 }
    let(:mocked_service_expectations) do
      {
        **all_service_expectations,
        Namespaces::Projects::Flows::Validation::FlowSettingValidationService => amount_of_flow_settings,
      }
    end

    before do
      flow.flow_settings = Array.new(amount_of_flow_settings) { create(:flow_setting, flow: flow) }
      flow.save!
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload).to eq(flow) }
  end

  context 'when primary runtime is not set' do
    before do
      namespace_project.update!(primary_runtime: nil)
    end

    let(:mocked_service_expectations) do
      {
        Namespaces::Projects::Flows::Validation::DataType::DataTypeValidationService => 0,
        Namespaces::Projects::Flows::Validation::FlowSettingValidationService => 0,
        Namespaces::Projects::Flows::Validation::NodeFunction::NodeFunctionValidationService => 0,
        Namespaces::Projects::Flows::Validation::FlowTypeValidationService => 0,
      }
    end

    it 'returns an error' do
      expect(service_response).to be_error
      expect(service_response.payload).to eq(:no_primary_runtime)
    end
  end

  # Some random examples to ensure the service works as expected
  context 'with real unmocked examples' do
    let(:runtime) { create(:runtime) }
    let(:namespace_project) { create(:namespace_project, primary_runtime: runtime) }
    let(:starting_node) do
      create(:node_function, runtime_function: create(:runtime_function_definition, runtime: runtime))
    end
    let(:flow) do
      create(:flow, project: namespace_project, flow_type: create(:flow_type, runtime: runtime),
                    starting_node: starting_node)
    end

    context 'with simplest flow' do
      let(:all_service_expectations) { {} }

      it { is_expected.to be_success }
      it { expect(service_response.payload).to eq(flow) }
    end
  end
end
