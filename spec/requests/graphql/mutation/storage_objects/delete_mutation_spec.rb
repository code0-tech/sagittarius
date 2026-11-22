# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'storageObjectsDelete Mutation' do
  include GraphqlHelpers

  let(:mutation) do
    <<~QUERY
      mutation($input: StorageObjectsDeleteInput!) {
        storageObjectsDelete(input: $input) {
          #{error_query}
          storageObject {
            id
            fileName
          }
        }
      }
    QUERY
  end

  let(:current_user) { create(:user) }
  let(:namespace) { current_user.ensure_namespace }
  let(:project) { create(:namespace_project, namespace: namespace) }
  let(:storage_object) { create(:storage_object, :committed, project: project) }
  let(:variables) { { input: { id: storage_object.to_global_id.to_s } } }

  before do
    post_graphql mutation, variables: variables, current_user: current_user
  end

  it 'deletes the storage object' do
    expect(graphql_data_at(:storage_objects_delete, :storage_object, :file_name)).to eq(storage_object.file_name)
    expect(StorageObject.exists?(storage_object.id)).to be(false)
  end
end
