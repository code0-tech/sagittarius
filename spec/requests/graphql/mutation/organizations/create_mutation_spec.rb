# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organizationsCreate Mutation' do
  include GraphqlHelpers

  let(:mutation) do
    <<~QUERY
      mutation($input: OrganizationsCreateInput!) {
        organizationsCreate(input: $input) {
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
      name: name,
    }
  end

  let(:variables) { { input: input } }
  let(:current_user) { create(:user) }

  before { post_graphql mutation, variables: variables, current_user: current_user }

  it 'creates organization' do
    expect(graphql_data_at(:organizations_create, :organization, :id)).to be_present

    organization = SagittariusSchema.object_from_id(graphql_data_at(:organizations_create, :organization, :id))

    expect(organization.name).to eq(input[:name])

    is_expected.to create_audit_event(
      :organization_created,
      author_id: current_user.id,
      entity_id: organization.id,
      entity_type: 'Organization',
      details: { name: input[:name] },
      target_id: organization.namespace.id,
      target_type: 'Namespace'
    )
  end

  context 'when organization name is taken' do
    let(:organization) { create(:organization) }
    let(:input) { { name: organization.name } }

    it 'returns an error' do
      expect(graphql_data_at(:organizations_create, :organization)).to be_nil
      expect(graphql_data_at(:organizations_create, :errors)).to include({ 'attribute' => 'name', 'type' => 'taken' })
    end
  end
end
