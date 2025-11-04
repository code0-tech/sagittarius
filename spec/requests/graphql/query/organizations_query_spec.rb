# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organization Query' do
  include GraphqlHelpers

  subject(:query!) { post_graphql query, current_user: current_user }

  let(:query) do
    <<~QUERY
      query {
        organizations {
          nodes {
            id
            name
          }
        }
      }
    QUERY
  end
  let(:current_user) { nil }
  let!(:first_organization) { create(:organization) }
  let!(:second_organization) { create(:organization) }

  before do
    create(:organization) # organization where the user isn't a member
  end

  context 'when anonymous' do
    it 'does not return organizations' do
      query!

      expect(graphql_data_at(:organizations, :nodes)).to be_empty
    end
  end

  context 'when logged in' do
    let(:current_user) { create(:user) }

    before do
      create(:namespace_member, namespace: first_organization.ensure_namespace, user: current_user)
      create(:namespace_member, namespace: second_organization.ensure_namespace, user: current_user)
    end

    it 'returns organizations where user is member' do
      query!

      expect(graphql_data_at(:organizations, :nodes)).to contain_exactly(
        a_graphql_entity_for(first_organization),
        a_graphql_entity_for(second_organization)
      )
    end
  end
end
