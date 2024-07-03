# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['Runtime'] do
  let(:fields) do
    %w[
      id
      namespace
      name
      description
      token
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('Runtime') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_runtime) }

  describe 'when existing runtime is requested', type: :request do
    include GraphqlHelpers

    let(:namespace) { create(:namespace) }
    let!(:runtime) { create(:runtime, namespace: namespace) }

    let(:current_user) do
      create(:user).tap do |user|
        create(:namespace_member, user: user, namespace: namespace)
      end
    end

    let(:query) do
      <<~QUERY
        query {
          namespace(id: "#{namespace.to_global_id}") {
            runtimes {
              nodes {
                id
                token
              }
            }
          }
        }
      QUERY
    end

    before { post_graphql query, current_user: current_user }

    it 'does not expose token' do
      expect(graphql_data_at(:namespace, :runtimes, :nodes, :id).first).to eq(runtime.to_global_id.to_s)
      expect(graphql_data_at(:namespace, :runtimes, :nodes, :token).first).to be_nil
    end
  end
end
