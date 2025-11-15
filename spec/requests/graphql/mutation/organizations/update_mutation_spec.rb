# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizationsUpdate Mutation' do
  include GraphqlHelpers

  let(:mutation) do
    <<~QUERY
      mutation($input: OrganizationsUpdateInput!) {
        organizationsUpdate(input: $input) {
          #{error_query}
          organization {
            id
            name
          }
        }
      }
    QUERY
  end

  let(:input) do
    name = generate(:organization_name)

    {
      organizationId: organization.to_global_id.to_s,
      name: name,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }
  let(:organization) do
    create(:organization).tap { |org| create(:namespace_member, user: current_user, namespace: org.ensure_namespace) }
  end

  before do
    stub_allowed_ability(OrganizationPolicy, :update_organization, user: current_user, subject: organization)
    post_graphql mutation, variables: variables, current_user: current_user
  end

  it 'updates organization' do
    expect(graphql_data_at(:organizations_update, :organization, :id)).to be_present

    organization = SagittariusSchema.object_from_id(graphql_data_at(:organizations_update, :organization, :id))

    expect(organization.name).to eq(input[:name])

    is_expected.to create_audit_event(
      :organization_updated,
      author_id: current_user.id,
      entity_id: organization.id,
      entity_type: 'Organization',
      details: { name: input[:name] },
      target_id: organization.namespace.id,
      target_type: 'Namespace'
    )
  end

  context 'when organization name is taken' do
    let(:existing_organization) { create(:organization) }
    let(:input) do
      {
        organizationId: organization.to_global_id.to_s,
        name: existing_organization.name,
      }
    end

    it 'returns an error' do
      expect(graphql_data_at(:organizations_update, :organization)).to be_nil
      expect(graphql_data_at(:organizations_update, :errors,
                             :details)).to include([{ 'attribute' => 'name', 'type' => 'taken' }])
    end
  end
end
