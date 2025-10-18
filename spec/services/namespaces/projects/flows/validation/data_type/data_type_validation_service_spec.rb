# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::Validation::DataType::DataTypeValidationService do
  subject(:service_response) { described_class.new(create_authentication(current_user), flow, data_type).execute }

  let(:current_user) { create(:user) }
  let(:runtime) { create(:runtime) }
  let(:namespace_project) { create(:namespace_project).tap { |np| np.primary_runtime = runtime } }
  let(:flow) { create(:flow, project: namespace_project) }
  let(:data_type) { create(:data_type, runtime: runtime) }

  context 'when data_type.runtime == runtime' do
    it { expect(service_response).to be_empty }
  end

  context 'when data_type.runtime != runtime' do
    let(:data_type) { create(:data_type) }

    it 'returns an error' do
      expect(service_response).to include(have_attributes(error_code: :data_type_runtime_mismatch))
    end
  end

  context 'when rules are set' do
    let(:data_type) { create(:data_type, runtime: runtime, rules: [create(:data_type_rule)]) }

    it { expect(service_response).to be_empty }
  end
end
