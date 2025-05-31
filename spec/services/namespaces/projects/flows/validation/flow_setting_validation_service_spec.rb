# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::Flows::Validation::FlowSettingValidationService do
  subject(:service_response) { described_class.new(create_authentication(current_user), flow, setting).execute }

  let(:default_payload) { flow }
  let(:current_user) { create(:user) }
  let(:runtime) { create(:runtime) }
  let(:namespace_project) { create(:namespace_project).tap { |np| np.primary_runtime = runtime } }
  let(:flow) { create(:flow, project: namespace_project) }
  let(:setting) { create(:flow_setting, flow: flow) }

  context 'when setting.flow == flow' do
    it { expect(service_response).to be_nil }
  end

  context 'when setting is invalid' do
    let(:setting) { build(:flow_setting, flow: flow) }

    before do
      allow(setting).to receive_messages(invalid?: true, errors: ActiveModel::Errors.new(setting))
    end

    it 'returns an error' do
      expect(service_response).to be_error
      expect(service_response.payload).to eq(setting.errors)
      expect(setting).to have_received(:invalid?)
      #                                         debug, payload, test -> 3 times
      expect(setting).to have_received(:errors).exactly(3).times
    end
  end
end
