# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'velorum query' do
  include GraphqlHelpers

  let(:query) do
    <<~QUERY
      query {
        velorum {
          enabled
          models {
            identifier
            name
            tokenCost
            types
          }
        }
      }
    QUERY
  end

  let(:current_user) { create(:user) }
  let(:client) { instance_double(Sagittarius::Velorum::Client) }
  let(:models_response) do
    Tucana::Velorum::ModelsResponse.new(
      models: [
        Tucana::Velorum::Model.new(
          identifier: 'gpt-5',
          name: 'GPT-5',
          token_cost: 1.5,
          type: %i[EXPLAIN GENERATE]
        ),
        Tucana::Velorum::Model.new(
          identifier: 'explainer',
          name: 'Explainer',
          token_cost: 0.5,
          type: [:EXPLAIN]
        )
      ]
    )
  end

  before do
    allow(Sagittarius::Configuration).to receive(:config)
      .and_return(velorum: { enabled: true })
    allow(Sagittarius::Velorum::Client).to receive(:new).and_return(client)
    allow(client).to receive(:models).and_return(models_response)
  end

  it 'proxies models from Velorum through gRPC' do
    post_graphql(query, current_user: current_user)

    expect(graphql_data_at(:velorum, :enabled)).to be(true)
    expect(graphql_data_at(:velorum, :models)).to contain_exactly(
      {
        'identifier' => 'gpt-5',
        'name' => 'GPT-5',
        'tokenCost' => 1.5,
        'types' => %w[EXPLAIN GENERATE],
      },
      {
        'identifier' => 'explainer',
        'name' => 'Explainer',
        'tokenCost' => 0.5,
        'types' => ['EXPLAIN'],
      }
    )
    expect(client).to have_received(:models)
  end

  context 'when Velorum is disabled' do
    before do
      allow(Sagittarius::Configuration).to receive(:config)
        .and_return(velorum: { enabled: false })
    end

    it 'returns disabled state and an empty model list without creating a Velorum client' do
      post_graphql(query, current_user: current_user)

      expect(graphql_data_at(:velorum, :enabled)).to be(false)
      expect(graphql_data_at(:velorum, :models)).to eq([])
      expect(graphql_errors).to be_nil
      expect(Sagittarius::Velorum::Client).not_to have_received(:new)
    end
  end
end
