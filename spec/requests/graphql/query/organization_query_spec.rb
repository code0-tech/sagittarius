# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'organization Query' do
  include GraphqlHelpers

  let(:query) do
    <<~QUERY
      query($organizationId: OrganizationID!) {
        organization(id: $organizationId) {
          id
          name
        }
      }
    QUERY
  end

  let(:current_user) { nil }
  let(:organization_id) { nil }
  let(:variables) { { organizationId: organization_id } }

  before { post_graphql query, variables: variables, current_user: current_user }

  context 'without an id' do
    it 'returns an error' do
      expect(graphql_data_at(:organization)).to be_nil
      expect(graphql_errors).not_to be_empty
    end
  end

  context 'with an invalid id' do
    let(:organization_id) { 'gid://sagittarius/Organizations/1' }

    it 'returns an error' do
      expect(graphql_data_at(:organization)).to be_nil
      expect(graphql_errors).not_to be_empty
    end
  end

  context 'with a valid id but out of range' do
    let(:organization_id) { 'gid://sagittarius/Organization/0' }

    it 'returns only nil' do
      expect(graphql_data_at(:organization)).to be_nil
      expect_graphql_errors_to_be_empty
    end
  end

  context 'with a valid id' do
    let(:organization) { create(:organization) }
    let(:organization_id) { "gid://sagittarius/Organization/#{organization.id}" }

    context 'when user is a member' do
      let(:current_user) do
        create(:user).tap do |user|
          create(:namespace_member, namespace: organization.ensure_namespace, user: user)
        end
      end

      it 'returns the organization' do
        expect(graphql_data_at(:organization, :id)).to eq(organization.to_global_id.to_s)
        expect(graphql_data_at(:organization, :name)).to eq(organization.name)
      end
    end

    context 'when user is not a member' do
      let(:current_user) { create(:user) }

      it 'returns only nil' do
        expect(graphql_data_at(:organization)).to be_nil
        expect_graphql_errors_to_be_empty
      end
    end

    context 'when user is anonymous' do
      it 'returns only nil' do
        expect(graphql_data_at(:organization)).to be_nil
        expect_graphql_errors_to_be_empty
      end
    end
  end
end
