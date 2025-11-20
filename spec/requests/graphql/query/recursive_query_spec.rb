# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Recursive Query Protection' do
  include GraphqlHelpers

  let(:current_user) { create(:user) }
  let(:organization) { create(:organization) }

  before do
    create(:namespace_member, namespace: organization.ensure_namespace, user: current_user)
  end

  context 'with deeply nested recursive query' do
    let(:query) do
      # Create a query with deep nesting that would cause recursion
      # Organization -> Namespace -> Parent (Organization) -> Namespace -> Parent...
      nested_levels = 25
      nested_query = 'id name'

      nested_levels.times do
        nested_query = <<~NESTED
          id
          name
          namespace {
            id
            parent {
              ... on Organization {
                #{nested_query}
              }
            }
          }
        NESTED
      end

      <<~QUERY
        query($organizationId: OrganizationID!) {
          organization(id: $organizationId) {
            #{nested_query}
          }
        }
      QUERY
    end

    let(:variables) { { organizationId: organization.to_global_id.to_s } }

    it 'blocks the query and returns an error' do
      post_graphql query, variables: variables, current_user: current_user

      expect(graphql_errors).not_to be_nil
      expect(graphql_errors).not_to be_empty
      expect(graphql_errors.first['message']).to include('depth')
    end
  end

  context 'with reasonably nested query' do
    let(:query) do
      # A reasonable query with moderate nesting (depth ~7-8)
      <<~QUERY
        query($organizationId: OrganizationID!) {
          organization(id: $organizationId) {
            id
            name
            namespace {
              id
              parent {
                ... on Organization {
                  id
                  name
                }
              }
            }
          }
        }
      QUERY
    end

    let(:variables) { { organizationId: organization.to_global_id.to_s } }

    it 'allows the query to execute' do
      post_graphql query, variables: variables, current_user: current_user

      expect(graphql_data_at(:organization)).not_to be_nil
      expect(graphql_data_at(:organization, :id)).to eq(organization.to_global_id.to_s)
    end
  end
end
