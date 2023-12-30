# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['UserSession'] do
  let(:fields) do
    %w[
      id
      user
      token
      active
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('UserSession') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_user_session) }

  describe 'when existing session is requested', type: :request do
    include GraphqlHelpers

    let(:session) { create(:user_session) }

    let(:query) do
      <<~QUERY
        query {
          currentAuthorization {
            __typename
            ...on UserSession {
              id
              token
            }
          }
        }
      QUERY
    end

    before { post_graphql query, headers: { authorization: "Session #{session.token}" } }

    it 'does not expose token', :aggregate_failures do
      expect(graphql_data_at(:current_authorization, :__typename)).to eq('UserSession')
      expect(graphql_data_at(:current_authorization, :id)).to eq(session.to_global_id.to_s)
      expect(graphql_data_at(:current_authorization, :token)).to be_nil
    end
  end
end
