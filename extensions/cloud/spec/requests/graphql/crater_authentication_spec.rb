# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Crater authentication' do
  include GraphqlHelpers

  let(:secret) { 'crater-secret' }
  # rubocop:disable-next RSpec/LetSetup -- needs to exist in the DB for the controller to find it
  let!(:crater_user) { create(:user, :crater) }
  let(:query) do
    <<~QUERY
      query {
        namespace(id: "#{namespace.to_global_id}") {
          id
        }
      }
    QUERY
  end

  let(:namespace) { create(:namespace) }

  before do
    allow(Sagittarius::Configuration).to receive(:config).and_wrap_original do |original|
      original.call.deep_merge(crater: { jwt_secret: secret })
    end
  end

  def jwt(secret, iat: Time.zone.now, exp: 1.minute.from_now)
    header = Base64.urlsafe_encode64({ alg: 'HS256', typ: 'JWT' }.to_json, padding: false)
    payload = Base64.urlsafe_encode64({ iat: iat.to_i, exp: exp.to_i }.to_json, padding: false)
    signature = Base64.urlsafe_encode64(
      OpenSSL::HMAC.digest('SHA256', secret, "#{header}.#{payload}"),
      padding: false
    )

    "#{header}.#{payload}.#{signature}"
  end

  context 'with a valid crater jwt' do
    before { post_graphql query, headers: { authorization: "Crater #{jwt(secret)}" } }

    it 'authenticates as the crater user and authorizes namespace access' do
      expect(graphql_data_at(:namespace, :id)).to eq(namespace.to_global_id.to_s)
    end
  end

  context 'with an expired crater jwt' do
    before { post_graphql query, headers: { authorization: "Crater #{jwt(secret, exp: 1.minute.ago)}" } }

    it 'does not authenticate' do
      expect(graphql_data_at(:namespace)).to be_nil
    end
  end

  context 'with a crater jwt signed by the wrong secret' do
    before { post_graphql query, headers: { authorization: "Crater #{jwt('wrong-secret')}" } }

    it 'does not authenticate' do
      expect(graphql_data_at(:namespace)).to be_nil
    end
  end

  context 'with a crater jwt whose lifetime exceeds the configured ttl' do
    before do
      post_graphql query, headers: { authorization: "Crater #{jwt(secret, iat: 10.minutes.ago)}" }
    end

    it 'does not authenticate' do
      expect(graphql_data_at(:namespace)).to be_nil
    end
  end
end
