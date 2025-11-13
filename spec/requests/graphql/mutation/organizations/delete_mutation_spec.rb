# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizationsDelete Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, current_user: current_user }

  let(:mutation) do
    <<~QUERY
      mutation($input: OrganizationsDeleteInput!) {
        organizationsDelete(input: $input) {
          #{error_query}
          organization {
            id
          }
        }
      }
    QUERY
  end

  let(:organization) { create(:organization) }
  let(:input) do
    {
      organizationId: organization.to_global_id.to_s,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  context 'when user is a member of the organization' do
    before do
      create(:namespace_member, namespace: organization.ensure_namespace, user: current_user)
      stub_allowed_ability(OrganizationPolicy, :delete_organization, user: current_user, subject: organization)
    end

    it 'deletes organization' do
      mutate!

      expect(graphql_data_at(:organizations_delete, :organization, :id)).to be_present

      expect(
        SagittariusSchema.object_from_id(
          graphql_data_at(:organizations_delete, :organization, :id)
        )
      ).to be_nil

      is_expected.to create_audit_event(
        :organization_deleted,
        author_id: current_user.id,
        entity_id: organization.id,
        entity_type: 'Organization',
        details: {},
        target_id: organization.namespace.id,
        target_type: 'Namespace'
      )
    end
  end

  context 'when user is not a member of the organization' do
    it 'returns an error' do
      mutate!

      expect(graphql_data_at(:organizations_delete, :organization)).to be_nil
      expect(graphql_data_at(:organizations_delete, :errors, :error_code)).to include('MISSING_PERMISSION')
    end
  end
end
