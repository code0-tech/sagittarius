# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizationLicensesCreate Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: NamespaceLicensesCreateInput!) {
        namespaceLicensesCreate(input: $input) {
          #{error_query}
          namespaceLicense {
            id
            namespace {
              id
            }
          }
        }
      }
    QUERY
  end

  let(:namespace) { create(:namespace) }
  let(:input) do
    data = create(:namespace_license).data

    {
      namespaceId: namespace.to_global_id.to_s,
      data: data,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user is a member of the namespace' do
    before do
      create(:namespace_member, namespace: namespace, user: current_user)
      stub_allowed_ability(NamespacePolicy, :create_namespace_license, user: current_user, subject: namespace)
      stub_allowed_ability(NamespacePolicy, :read_namespace_license, user: current_user, subject: namespace)
    end

    it 'creates namespace license' do
      mutate!

      expect(graphql_data_at(:namespace_licenses_create, :namespace_license, :id)).to be_present

      namespace_license = SagittariusSchema.object_from_id(
        graphql_data_at(:namespace_licenses_create, :namespace_license, :id)
      )

      expect(namespace_license.namespace).to eq(namespace)

      is_expected.to create_audit_event(
        :namespace_license_created,
        author_id: current_user.id,
        entity_id: namespace_license.id,
        entity_type: 'NamespaceLicense',
        target_id: namespace.id,
        target_type: 'Namespace'
      )
    end

    context 'when license is invalid' do
      let(:input) { { namespaceId: namespace.to_global_id.to_s, data: 'invalid license' } }

      it 'returns an error' do
        mutate!

        expect(graphql_data_at(:namespace_licenses_create, :namespace_license)).to be_nil
        expect(
          graphql_data_at(:namespace_licenses_create, :errors)
        ).to include({ 'attribute' => 'data', 'type' => 'invalid' })
      end
    end
  end

  context 'when user is not a member of the namespace' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:namespace_licenses_create, :namespace_license)).to be_nil
      expect(graphql_data_at(:namespace_licenses_create, :errors)).to include({ 'message' => 'missing_permission' })
    end
  end
end
