# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'namespacesLicensesDelete Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: NamespacesLicensesDeleteInput!) {
        namespacesLicensesDelete(input: $input) {
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
  let(:license) { create(:namespace_license, namespace: namespace) }
  let(:input) do
    {
      namespaceLicenseId: license.to_global_id.to_s,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user is a member of the namespace' do
    before do
      create(:namespace_member, namespace: namespace, user: current_user)
      stub_allowed_ability(NamespacePolicy, :delete_namespace_license, user: current_user, subject: namespace)
      stub_allowed_ability(NamespacePolicy, :read_namespace_license, user: current_user, subject: namespace)
    end

    it 'deletes namespace license' do
      mutate!

      expect(graphql_data_at(:namespaces_licenses_delete, :namespace_license, :id)).to be_present

      namespace_license = SagittariusSchema.object_from_id(
        graphql_data_at(:namespaces_licenses_delete, :namespace_license, :id)
      )

      expect(namespace_license).to be_nil

      is_expected.to create_audit_event(
        :namespace_license_deleted,
        author_id: current_user.id,
        entity_id: license.id,
        entity_type: 'NamespaceLicense',
        target_id: namespace.id,
        target_type: 'Namespace'
      )
    end
  end

  context 'when user is not a member of the namespace' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:namespaces_licenses_delete, :namespace_license)).to be_nil
      expect(graphql_data_at(:namespaces_licenses_delete, :errors, :error_code)).to include('MISSING_PERMISSION')
    end
  end
end
