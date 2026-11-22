# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StorageObjects::CreateService do
  subject(:service_response) do
    described_class.new(authentication, project: project, attachment: attachment, expires_at: expires_at,
                                        execution_identifier: execution_identifier).execute
  end

  let(:current_user) { create(:user) }
  let(:authentication) { create_authentication(current_user) }
  # Personal namespace -> owner is a namespace administrator, so create_storage_object is allowed.
  let(:namespace) { current_user.ensure_namespace }
  let(:project) { create(:namespace_project, namespace: namespace) }
  let(:attachment) { fixture_file_upload(Rails.root.join('spec/fixtures/square_image.webp'), 'image/webp') }
  let(:expires_at) { nil }
  let(:execution_identifier) { nil }

  context 'when parameters are missing' do
    context 'when project is nil' do
      let(:project) { nil }

      it { is_expected.to be_error }
      it { expect(service_response.payload[:error_code]).to eq(:project_not_found) }
    end

    context 'when attachment is nil' do
      let(:attachment) { nil }

      it { is_expected.to be_error }
      it { expect(service_response.payload[:error_code]).to eq(:missing_parameter) }
    end
  end

  context 'when the attachment is not an uploaded file' do
    let(:attachment) { 'just a string' }

    it { is_expected.to be_error }
    it { expect(service_response.payload[:error_code]).to eq(:invalid_attachment) }
  end

  context 'when the user has no access to the project' do
    let(:project) { create(:namespace_project) }

    it { is_expected.to be_error }
    it { expect(service_response.payload[:error_code]).to eq(:project_not_found) }
    it { expect { service_response }.not_to change { StorageObject.count } }
  end

  context 'when the user may read but not upload' do
    let(:project) { create(:namespace_project) }

    before do
      stub_allowed_ability(NamespacePolicy, :create_namespace_project, user: current_user, subject: project.namespace)
    end

    it { is_expected.to be_error }
    it { expect(service_response.payload[:error_code]).to eq(:missing_permission) }
  end

  context 'when the file exceeds the per-file size limit' do
    before { namespace.update!(max_file_size_bytes: 1) }

    it { is_expected.to be_error }
    it { expect(service_response.payload[:error_code]).to eq(:file_too_large) }
  end

  context 'when the namespace quota is exhausted' do
    before { namespace.update!(storage_quota_bytes: 1) }

    it { is_expected.to be_error }
    it { expect(service_response.payload[:error_code]).to eq(:quota_exceeded) }
  end

  context 'when the upload is valid' do
    it { is_expected.to be_success }

    it 'stores a committed, non-expiring user upload with metadata and an attached blob' do
      storage_object = service_response.payload.reload
      expect(storage_object).to be_status_committed
      expect(storage_object).to be_origin_user_upload
      expect(storage_object.project).to eq(project)
      expect(storage_object.created_by).to eq(current_user)
      expect(storage_object.blob).to be_attached
      expect(storage_object.byte_size).to be_positive
      expect(storage_object.checksum).to start_with('sha256:')
      expect(storage_object.expires_at).to be_nil
    end

    it 'counts against the namespace quota once committed' do
      expect { service_response }.to change { namespace.reload.storage_used_bytes }.from(0)
    end

    it 'counts the files of all projects of the namespace' do
      create(:storage_object, :committed, project: create(:namespace_project, namespace: namespace), byte_size: 7)

      expect(namespace.storage_used_bytes).to eq(7)
    end

    it do
      is_expected.to create_audit_event(
        :storage_object_created,
        author_id: current_user.id,
        entity_type: 'StorageObject',
        target_type: 'NamespaceProject',
        target_id: project.id
      )
    end

    context 'with expires_at and an execution identifier' do
      let(:expires_at) { 1.day.from_now.change(usec: 0) }
      let(:execution_identifier) { 'execution-1' }

      it 'persists them' do
        expect(service_response.payload).to have_attributes(expires_at: expires_at,
                                                            execution_identifier: 'execution-1')
      end
    end
  end

  context 'when authenticated as a runtime' do
    let(:runtime) { create(:runtime, namespace: namespace) }
    let(:authentication) { create_authentication(runtime, :runtime) }

    context 'when the runtime is assigned to the project' do
      before { create(:namespace_project_runtime_assignment, runtime: runtime, namespace_project: project) }

      it { is_expected.to be_success }

      it 'stores an execution output without author' do
        storage_object = service_response.payload
        expect(storage_object).to be_origin_execution_output
        expect(storage_object.created_by).to be_nil
      end

      it { expect { service_response }.not_to change { AuditEvent.count } }
    end

    context 'when the runtime is not assigned to the project' do
      it { is_expected.to be_error }
      it { expect(service_response.payload[:error_code]).to eq(:project_not_found) }
      it { expect { service_response }.not_to change { StorageObject.count } }
    end
  end
end
