# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::Validation::ValidationService do
  subject(:service_response) { described_class.new(create_authentication(current_user), flow).execute }

  let(:runtime) { create(:runtime) }
  let(:namespace_project) { create(:namespace_project).tap { |np| np.update(primary_runtime: runtime) } }
  let(:starting_node) { create(:node_function, runtime_function_definition: create(:runtime_function_definition, runtime: runtime)) }
  let(:flow_type) { create(:flow_type, runtime: runtime) }
  let(:flow) { create(:flow, project: namespace_project, flow_type: flow_type, starting_node: starting_node) }

  context 'when validation succeeds' do
    let(:current_user) { create(:user) }

    it { is_expected.to be_success }
    it { expect(service_response.payload).to eq flow }
    it { expect(service_response.message).to eq 'Validation service executed successfully' }
  end

  # Add more test cases when validation logic is implemented in ValidationService
end
