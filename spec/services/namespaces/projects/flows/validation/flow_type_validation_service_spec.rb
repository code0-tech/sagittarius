# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::Validation::FlowTypeValidationService do
  subject(:service_response) { described_class.new(create_authentication(current_user), flow, flow_type).execute }

  let(:default_payload) { flow }
  let(:current_user) { create(:user) }
  let(:runtime) { create(:runtime) }
  let(:namespace_project) { create(:namespace_project).tap { |np| np.primary_runtime = runtime } }
  let(:flow_type) { create(:flow_type, runtime: runtime) }
  let(:flow) { create(:flow, flow_type: flow_type, project: namespace_project) }

  context 'when primary runtime is equal to flow type runtime' do
    it { expect(service_response).to be_empty }
  end

  context 'when primary runtime is not equal to flow type runtime' do
    let(:flow_type) { create(:flow_type) }

    it 'returns an error' do
      expect(service_response).to include(have_attributes(error_code: :flow_type_runtime_mismatch))
    end
  end
end
