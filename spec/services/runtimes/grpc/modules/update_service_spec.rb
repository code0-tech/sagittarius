# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Runtimes::Grpc::Modules::UpdateService do
  describe '#execute' do
    let(:runtime) { create(:runtime) }
    let(:project) { create(:namespace_project) }
    let!(:assignment) do
      create(:namespace_project_runtime_assignment,
             runtime: runtime,
             namespace_project: project,
             compatible: false)
    end
    let(:compatibility_service) { instance_double(Runtimes::CheckRuntimeCompatibilityService, execute: compatibility_response) }
    let(:compatibility_response) { ServiceResponse.success }

    before do
      allow(FlowHandler).to receive(:update_runtime)
      allow(Runtimes::CheckRuntimeCompatibilityService).to receive(:new).and_return(compatibility_service)
    end

    it 'updates assignment compatibility before updating the runtime flow stream' do
      response = described_class.new(runtime, []).execute

      expect(response).to be_success
      expect(Runtimes::CheckRuntimeCompatibilityService).to have_received(:new).with(runtime, project)
      expect(assignment.reload.compatible).to be(true)
      expect(FlowHandler).to have_received(:update_runtime).with(runtime)
    end

    context 'when the runtime is not compatible with a project assignment' do
      let(:compatibility_response) { ServiceResponse.error(message: 'Not compatible', error_code: :missing_definition) }

      it 'marks the assignment as incompatible before updating the runtime flow stream' do
        assignment.update!(compatible: true)

        response = described_class.new(runtime, []).execute

        expect(response).to be_success
        expect(assignment.reload.compatible).to be(false)
        expect(FlowHandler).to have_received(:update_runtime).with(runtime)
      end
    end
  end
end
