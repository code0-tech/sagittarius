# frozen_string_literal: true

require 'rails_helper'

Rspec.describe Namespaces::Projects::Flows::Validation::NodeFunction::ReferenceValueValidationService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), flow, first_node, reference_value).execute
  end

  include_context 'with mocked services'

  let(:mocked_service_expectations) do
    {
      Namespaces::Projects::Flows::Validation::DataType::DataTypeIdentifierValidationService => 1,
    }
  end

  let(:current_user) { create(:user) }
  let(:runtime) { create(:runtime) }
  let(:namespace_project) { create(:namespace_project, primary_runtime: runtime) }
  let(:flow) { create(:flow, project: namespace_project, starting_node: first_node) }

  let(:first_node) do
    create(:node_function,
           runtime_function: create(:runtime_function_definition, runtime: runtime),
           node_parameters: [
             create(:node_parameter,
                    runtime_parameter: create(:runtime_parameter_definition, data_type: data_type_identifier),
                    literal_value: nil,
                    function_value: create(:node_function))
           ],
           next_node: second_node)
  end
  let(:second_node) do
    create(:node_function,
           runtime_function: create(:runtime_function_definition, runtime: runtime),
           node_parameters: [
             create(:node_parameter,
                    runtime_parameter: create(:runtime_parameter_definition, data_type: data_type_identifier),
                    literal_value: nil,
                    function_value: create(:node_function, node_parameters: [
                                             create(:node_parameter,
                                                    runtime_parameter: create(:runtime_parameter_definition,
                                                                              data_type: data_type_identifier))
                                           ])),
             create(:node_parameter,
                    runtime_parameter: create(:runtime_parameter_definition, data_type: data_type_identifier),
                    literal_value: nil,
                    function_value: create(:node_function))
           ])
  end
  let(:data_type_identifier) do
    create(:data_type_identifier, generic_key: 'T', runtime: runtime)
  end
  let(:primary_level) { 0 }
  let(:secondary_level) { 0 }
  let(:tertiary_level) { nil }
  let(:reference_value) do
    create(:reference_value,
           data_type_identifier: data_type_identifier,
           primary_level: primary_level,
           secondary_level: secondary_level,
           tertiary_level: tertiary_level)
  end

  context 'with horizontal reference' do
    let(:secondary_level) { 0 }

    it { expect(service_response).to be_nil }

    context 'with horizontal reference out of bounds' do
      let(:secondary_level) { 2 }

      it { expect(service_response).to be_error }
      it { expect(service_response.payload).to eq(:secondary_level_not_found) }
    end
  end

  context 'with primary level' do
    let(:primary_level) { 1 }

    it { expect(service_response).to be_nil }

    context 'with primary level of 2' do
      let(:primary_level) { 2 }

      it { expect(service_response).to be_nil }
    end

    context 'with primary level of 3' do
      let(:primary_level) { 3 }

      it { expect(service_response).to be_nil }
    end

    context 'with primary level out of bounds' do
      let(:primary_level) { 4 }

      it { expect(service_response).to be_error }
      it { expect(service_response.payload).to eq(:primary_level_not_found) }
    end
  end

  context 'with tertiary level' do
    let(:primary_level) { 0 }
    let(:secondary_level) { 1 }
    let(:tertiary_level) { 1 }

    it { expect(service_response).to be_nil }

    context 'with not existing parameter' do
      let(:primary_level) { 0 }
      let(:secondary_level) { 0 }
      let(:tertiary_level) { 1 }

      it { expect(service_response.payload).to eq(:tertiary_level_exceeds_parameters) }
    end

    context 'with no parameter' do
      let(:primary_level) { 1 }
      let(:secondary_level) { 0 }
      let(:tertiary_level) { nil }

      it { expect(service_response).to be_nil }

      context 'with deeper primary level' do
        let(:primary_level) { 1 }
        let(:secondary_level) { 0 }
        let(:tertiary_level) { 0 }

        it { expect(service_response.payload).to eq(:tertiary_level_exceeds_parameters) }
      end

      context 'with deeper primary level nested' do
        let(:primary_level) { 2 }
        let(:secondary_level) { 0 }
        let(:tertiary_level) { 0 }

        it { expect(service_response).to be_nil }
      end
    end

    context 'with tertiary level out of bounds' do
      let(:primary_level) { 0 }
      let(:secondary_level) { 0 }
      let(:tertiary_level) { 2 }

      it { expect(service_response).to be_error }
      it { expect(service_response.payload).to eq(:tertiary_level_exceeds_parameters) }
    end
  end
end
