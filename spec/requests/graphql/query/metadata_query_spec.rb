# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'metadata Query' do
  include GraphqlHelpers

  let(:query) do
    <<~QUERY
      query {
        metadata {
          version
          extensions
        }
      }
    QUERY
  end

  before { post_graphql query }

  it 'returns the application version' do
    expect(graphql_data_at(:metadata, :version)).to eq(Sagittarius::VERSION)
  end

  it 'returns the list of active extensions' do
    expected_extensions = Sagittarius::Extensions.active.map(&:to_s)
    expect(graphql_data_at(:metadata, :extensions)).to match_array(expected_extensions)
  end

  it 'does not require authentication' do
    expect(graphql_errors).to be_nil
  end
end
