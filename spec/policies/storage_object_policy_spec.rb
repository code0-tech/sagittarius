# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StorageObjectPolicy do
  subject { described_class.new(create_authentication(current_user), storage_object) }

  let(:current_user) { create(:user) }
  let(:storage_object) { create(:storage_object) }

  context 'when the user is a member of the owning namespace with a role granting read access' do
    before do
      stub_allowed_ability(
        NamespacePolicy,
        :create_namespace_project,
        user: current_user,
        subject: storage_object.project.namespace
      )
    end

    it { is_expected.to be_allowed(:read_storage_object) }
    it { is_expected.to be_disallowed(:delete_storage_object) }
  end

  context 'when the storage object belongs to a project of the personal namespace' do
    let(:namespace) { current_user.ensure_namespace }
    let(:project) { create(:namespace_project, namespace: namespace) }
    let(:storage_object) { create(:storage_object, project: project) }

    it { is_expected.to be_allowed(:read_storage_object) }
    it { is_expected.to be_allowed(:create_storage_object) }
    it { is_expected.to be_allowed(:delete_storage_object) }
  end

  context 'when the user is only a member without project abilities' do
    before { create(:namespace_member, namespace: storage_object.project.namespace, user: current_user) }

    it { is_expected.to be_disallowed(:read_storage_object) }
    it { is_expected.to be_disallowed(:delete_storage_object) }
  end

  context 'when the user has no access to the owning project' do
    it { is_expected.to be_disallowed(:read_storage_object) }
    it { is_expected.to be_disallowed(:delete_storage_object) }
  end

  context 'when authenticated as a runtime' do
    subject { described_class.new(create_authentication(runtime, :runtime), storage_object) }

    let(:runtime) { create(:runtime) }

    context 'when assigned to the project' do
      before do
        create(:namespace_project_runtime_assignment, runtime: runtime, namespace_project: storage_object.project)
      end

      it { is_expected.to be_allowed(:read_storage_object) }
      it { is_expected.to be_allowed(:create_storage_object) }
      it { is_expected.to be_disallowed(:delete_storage_object) }
    end

    context 'when assigned to another project only' do
      before { create(:namespace_project_runtime_assignment, runtime: runtime) }

      it { is_expected.to be_disallowed(:read_storage_object) }
      it { is_expected.to be_disallowed(:create_storage_object) }
    end
  end
end
