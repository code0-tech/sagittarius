# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StorageObjects::CompleteUploadService do
  subject(:service_response) { described_class.new(storage_object, io: io).execute }

  let(:user) { create(:user) }
  let(:namespace) { user.ensure_namespace }
  let(:project) { create(:namespace_project, namespace: namespace) }
  let(:storage_object) do
    create(:storage_object, project: project, created_by: user, file_name: 'a.txt', content_type: 'text/plain',
                            byte_size: 0, checksum: nil)
  end
  let(:io) { StringIO.new('hello world') }

  context 'when the object is pending' do
    it { is_expected.to be_success }

    it 'commits with size, sha256 checksum and an attached blob using the prepared name and type' do
      service_response
      storage_object.reload

      expect(storage_object).to be_status_committed
      expect(storage_object.byte_size).to eq(11)
      expect(storage_object.checksum).to eq("sha256:#{Digest::SHA256.hexdigest('hello world')}")
      expect(storage_object.blob).to be_attached
      expect(storage_object.blob.download).to eq('hello world')
      expect(storage_object.blob.filename.to_s).to eq('a.txt')
      expect(storage_object.blob.content_type).to eq('text/plain')
    end

    it 'counts against the namespace quota' do
      expect { service_response }.to change { namespace.reload.storage_used_bytes }.from(0).to(11)
    end

    it do
      is_expected.to create_audit_event(
        :storage_object_created,
        author_id: user.id,
        entity_type: 'StorageObject',
        target_type: 'NamespaceProject',
        target_id: project.id
      )
    end

    context 'without a creating user (runtime output)' do
      before { storage_object.update!(created_by: nil, origin: :execution_output) }

      it { is_expected.to be_success }
      it { expect { service_response }.not_to change { AuditEvent.count } }
    end
  end

  context 'when the object is already committed' do
    let(:storage_object) { create(:storage_object, :committed, project: project) }

    it { is_expected.to be_error }
    it { expect(service_response.payload[:error_code]).to eq(:storage_object_not_found) }
  end

  context 'when the object was committed concurrently' do
    it 'rejects the stale instance after re-reading it under the lock' do
      StorageObject.find(storage_object.id).update!(status: :committed)

      expect(service_response.payload[:error_code]).to eq(:storage_object_not_found)
      expect(storage_object.reload.blob).not_to be_attached
    end
  end

  context 'when the file exceeds the per-file size limit' do
    before { namespace.update!(max_file_size_bytes: 5) }

    it { expect(service_response.payload[:error_code]).to eq(:file_too_large) }
    it { expect { service_response }.not_to(change { storage_object.reload.status }) }
  end

  context 'when the namespace quota is exhausted' do
    before { namespace.update!(storage_quota_bytes: 5) }

    it { expect(service_response.payload[:error_code]).to eq(:quota_exceeded) }
    it { expect { service_response }.not_to(change { storage_object.reload.status }) }
  end
end
