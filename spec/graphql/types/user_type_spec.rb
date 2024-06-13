# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['User'] do
  let(:fields) do
    %w[
      id
      username
      email
      namespaceMemberships
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('User') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_user) }

  context 'when requesting namespace memberships' do
    it_behaves_like 'prevents N+1 queries (graphql)' do
      let(:query) do
        <<~QUERY
          query {
            currentUser {
              namespaceMemberships {
                count
                nodes {
                  id
                  user { username }
                  namespace { id }
                }
              }
            }
          }
        QUERY
      end

      before { create(:namespace_member, user: current_user) }

      let(:current_user) { create(:user) }

      let(:create_new_record) do
        -> { create(:namespace_member, user: current_user) }
      end
    end
  end
end
