# frozen_string_literal: true

require 'rails_helper'

Rspec.describe Namespaces::Projects::Flows::Validation::NodeFunction::GenericMapperValidationService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), flow, parameter, generic_mapper).execute
  end

  let(:current_user) { create(:user) }
  let(:runtime) { create(:runtime) }
  let(:namespace_project) { create(:namespace_project, primary_runtime: runtime) }
  let(:flow) { create(:flow, project: namespace_project, starting_node: node) }

  let(:parameter) do
    create(:node_parameter,
           runtime_parameter:
             create(:runtime_parameter_definition,
                    data_type: create(:data_type_identifier,
                                      generic_type: create(:generic_type,
                                                           data_type: create(:data_type),
                                                           generic_mappers: [generic_mapper]))),
           literal_value: nil,
           function_value: create(:node_function))
  end
  let(:node) do
    create(:node_function,
           runtime_function: create(:runtime_function_definition,
                                    generic_keys: ['T'],
                                    runtime: runtime),
           node_parameters: [
             parameter
           ])
  end
  let(:data_type_identifier) do
    create(:data_type_identifier, generic_key: 'T', runtime: runtime)
  end
  let(:generic_mapper) do
    create(:generic_mapper, sources: [data_type_identifier], target: 'T')
  end

  context 'when generic mapper points to a existing generic_key' do
    it { expect(service_response).to be_empty }
  end
end
