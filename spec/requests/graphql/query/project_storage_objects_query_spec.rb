# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'project storageObjects Query' do
  include GraphqlHelpers

  let(:query) do
    <<~QUERY
      query($namespaceId: NamespaceID!, $projectId: NamespaceProjectID!, $storageObjectId: StorageObjectID!) {
        namespace(id: $namespaceId) {
          storageQuotaBytes
          storageUsedBytes
          project(id: $projectId) {
            storageObjects {
              nodes {
                id
                fileName
                project { id }
              }
            }
            storageObject(id: $storageObjectId) {
              id
              fileName
            }
          }
        }
      }
    QUERY
  end

  let(:current_user) { create(:user) }
  let(:namespace) { current_user.ensure_namespace }
  let(:project) { create(:namespace_project, namespace: namespace) }
  let(:other_project) { create(:namespace_project, namespace: namespace) }
  let!(:own_file) { create(:storage_object, :committed, project: project) }
  let!(:other_file) { create(:storage_object, :committed, project: other_project) }
  let(:requested_file) { own_file }
  let(:variables) do
    { namespaceId: namespace.to_global_id.to_s, projectId: project.to_global_id.to_s,
      storageObjectId: requested_file.to_global_id.to_s }
  end

  before { post_graphql query, variables: variables, current_user: current_user }

  it 'lists only the files of the project and exposes the namespace quota' do
    expect(graphql_data_at(:namespace, :project, :storage_objects, :nodes, :id)).to eq([own_file.to_global_id.to_s])
    expect(graphql_data_at(:namespace, :project, :storage_object, :id)).to eq(own_file.to_global_id.to_s)
    expect(graphql_data_at(:namespace, :storage_used_bytes)).to eq(own_file.byte_size + other_file.byte_size)
  end

  context 'when requesting a file of another project' do
    let(:requested_file) { other_file }

    it 'does not find it' do
      expect(graphql_data_at(:namespace, :project, :storage_object)).to be_nil
    end
  end

  context 'when requesting a non-existent file' do
    let(:variables) do
      { namespaceId: namespace.to_global_id.to_s, projectId: project.to_global_id.to_s,
        storageObjectId: 'gid://sagittarius/StorageObject/0' }
    end

    it 'is indistinguishable from a file of another project' do
      expect(graphql_data_at(:namespace, :project, :storage_object)).to be_nil
    end
  end
end
