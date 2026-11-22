# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StorageObjects::DeleteService do
  subject(:service_response) { described_class.new(create_authentication(current_user), storage_object).execute }

  let(:current_user) { create(:user) }
  let(:namespace) { current_user.ensure_namespace }
  let(:project) { create(:namespace_project, namespace: namespace) }
  let(:storage_object) { create(:storage_object, :committed, project: project) }

  context 'when the storage object is nil' do
    let(:storage_object) { nil }

    it { is_expected.to be_error }
    it { expect(service_response.payload[:error_code]).to eq(:storage_object_not_found) }
  end

  context 'when the user has no access to the project' do
    let(:project) { create(:namespace_project) }

    before { storage_object }

    it { is_expected.to be_error }
    it { expect(service_response.payload[:error_code]).to eq(:storage_object_not_found) }
    it { expect { service_response }.not_to change { StorageObject.count } }
  end

  context 'when the user may read but not delete it' do
    let(:project) { create(:namespace_project) }

    before do
      storage_object
      stub_allowed_ability(NamespacePolicy, :create_namespace_project, user: current_user, subject: project.namespace)
    end

    it { is_expected.to be_error }
    it { expect(service_response.payload[:error_code]).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { StorageObject.count } }
  end

  context 'when the user may delete it' do
    it { is_expected.to be_success }

    it 'removes the record and purges the blob' do
      storage_object
      expect { service_response }.to change { StorageObject.count }.by(-1)
                                 .and change { ActiveStorage::Blob.count }.by(-1)
    end

    it do
      is_expected.to create_audit_event(
        :storage_object_deleted,
        author_id: current_user.id,
        entity_type: 'StorageObject',
        target_type: 'NamespaceProject',
        target_id: project.id
      )
    end
  end
end
