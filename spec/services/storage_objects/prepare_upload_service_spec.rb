# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StorageObjects::PrepareUploadService do
  subject(:service_response) do
    described_class.new(authentication, project: project, file_name: file_name, content_type: content_type,
                                        expires_at: expires_at, execution_identifier: 'exec-1').execute
  end

  let(:current_user) { create(:user) }
  let(:authentication) { create_authentication(current_user) }
  let(:namespace) { current_user.ensure_namespace }
  let(:project) { create(:namespace_project, namespace: namespace) }
  let(:file_name) { 'report.pdf' }
  let(:content_type) { 'application/pdf' }
  let(:expires_at) { nil }

  context 'when the project is nil' do
    let(:project) { nil }

    it { is_expected.to be_error }
    it { expect(service_response.payload[:error_code]).to eq(:project_not_found) }
  end

  context 'when the user has no access to the project' do
    let(:project) { create(:namespace_project) }

    it { expect(service_response.payload[:error_code]).to eq(:project_not_found) }
    it { expect { service_response }.not_to change { StorageObject.count } }
  end

  context 'when the user may read but not create' do
    let(:project) { create(:namespace_project) }

    before do
      stub_allowed_ability(NamespacePolicy, :create_namespace_project, user: current_user, subject: project.namespace)
    end

    it { expect(service_response.payload[:error_code]).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { StorageObject.count } }
  end

  context 'when the file name is blank' do
    let(:file_name) { '' }

    it { expect(service_response.payload[:error_code]).to eq(:invalid_storage_object) }
    it { expect { service_response }.not_to change { StorageObject.count } }
  end

  context 'when the content type is blank' do
    let(:content_type) { '' }

    it 'falls back to a binary type' do
      expect(service_response.payload.content_type).to eq('application/octet-stream')
    end
  end

  context 'when allowed' do
    let(:expires_at) { 1.day.from_now.change(usec: 0) }

    it { is_expected.to be_success }

    it 'creates an empty pending user upload' do
      expect(service_response.payload).to have_attributes(
        status: 'pending', origin: 'user_upload', created_by: current_user, project: project, byte_size: 0,
        file_name: 'report.pdf', content_type: 'application/pdf', expires_at: expires_at,
        execution_identifier: 'exec-1'
      )
      expect(service_response.payload.blob).not_to be_attached
    end

    it { expect { service_response }.not_to change { AuditEvent.count } }
  end

  context 'when authenticated as a runtime' do
    let(:runtime) { create(:runtime, namespace: namespace) }
    let(:authentication) { create_authentication(runtime, :runtime) }

    context 'when the runtime is assigned to the project' do
      before { create(:namespace_project_runtime_assignment, runtime: runtime, namespace_project: project) }

      it 'creates a pending execution output without author' do
        expect(service_response.payload).to have_attributes(status: 'pending', origin: 'execution_output',
                                                            created_by: nil)
      end
    end

    context 'when the runtime is not assigned to the project' do
      it { expect(service_response.payload[:error_code]).to eq(:project_not_found) }
      it { expect { service_response }.not_to change { StorageObject.count } }
    end
  end
end
