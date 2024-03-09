# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['User'] do
  let(:fields) do
    %w[
      id
      username
      email
      organizationMemberships
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('User') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_user) }

  context 'when requesting organization memberships' do
    it_behaves_like 'prevents N+1 queries (graphql)' do
      let(:query) do
        <<~QUERY
          query {
            currentUser {
              organizationMemberships {
                count
                nodes {
                  id
                  user { username }
                  organization { name }
                }
              }
            }
          }
        QUERY
      end

      before { create(:organization_member, user: current_user) }

      let(:current_user) { create(:user) }

      let(:create_new_record) do
        -> { create(:organization_member, user: current_user) }
      end
    end
  end
end
