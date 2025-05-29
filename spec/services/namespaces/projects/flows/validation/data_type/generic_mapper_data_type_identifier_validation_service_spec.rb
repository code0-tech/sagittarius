# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::Validation::DataType::GenericMapperDataTypeIdentifierValidationService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), flow, parameter, mapper, data_type_identifier).execute
  end

  include_context 'with mocked services'

  let(:all_service_expectations) do
    # Default case
    {
      Namespaces::Projects::Flows::Validation::DataType::GenericDataTypeIdentifierValidationService => 1,
      Namespaces::Projects::Flows::Validation::DataType::DataTypeValidationService => 0,
      Namespaces::Projects::Flows::Validation::NodeFunction::GenericTypeValidationService => 0,
    }
  end
  let(:current_user) { create(:user) }
  let(:runtime) { create(:runtime) }
  let(:namespace_project) { create(:namespace_project).tap { |np| np.primary_runtime = runtime } }
  let(:parameter) do
    create(:node_parameter, runtime: runtime,
                            node_function: create(:node_function,
                                                  runtime: runtime))
  end
  let(:flow) { create(:flow, project: namespace_project) }
  let(:data_type_identifier) { create(:data_type_identifier, data_type: create(:data_type), runtime: runtime) }
  let(:generic_mapper) { create(:generic_mapper, source: data_type_identifier, target: 'T') }
  let(:mocked_service_expectations) { all_service_expectations }
  let(:default_execute_response) { nil }
end
