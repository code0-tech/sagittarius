# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Runtimes::Grpc::Modules::UpdateService do
  describe '#execute' do
    let(:runtime) { create(:runtime) }

    before do
      allow(UpdateRuntimeCompatibilityJob).to receive(:perform_later)
    end

    it 'schedules runtime compatibility updates' do
      response = described_class.new(runtime, []).execute

      expect(response).to be_success
      expect(UpdateRuntimeCompatibilityJob).to have_received(:perform_later).with({ runtime_id: runtime.id })
    end
  end
end
