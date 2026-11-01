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

  def jwt(secret, iat: Time.zone.now, exp: 1.minute.from_now, sub: nil)
    payload = { iat: iat.to_i, exp: exp.to_i }
    payload[:sub] = sub if sub.present?

    header = Base64.urlsafe_encode64({ alg: 'HS256', typ: 'JWT' }.to_json, padding: false)
    encoded_payload = Base64.urlsafe_encode64(payload.to_json, padding: false)
    signature = Base64.urlsafe_encode64(
      OpenSSL::HMAC.digest('SHA256', secret, "#{header}.#{encoded_payload}"),
      padding: false
    )

    "#{header}.#{encoded_payload}.#{signature}"
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

  context 'with a crater jwt impersonating a user who is not a namespace member' do
    let(:impersonated_user) { create(:user) }

    before do
      post_graphql query, headers: { authorization: "Crater #{jwt(secret, sub: impersonated_user.to_global_id.to_s)}" }
    end

    it 'authorizes based on the impersonated user and denies access' do
      expect(graphql_data_at(:namespace)).to be_nil
    end
  end

  context 'with a crater jwt impersonating a user who is a namespace member' do
    let(:impersonated_user) { create(:user) }

    before do
      create(:namespace_member, namespace: namespace, user: impersonated_user)
      post_graphql query, headers: { authorization: "Crater #{jwt(secret, sub: impersonated_user.to_global_id.to_s)}" }
    end

    it 'authorizes based on the impersonated user and allows access' do
      expect(graphql_data_at(:namespace, :id)).to eq(namespace.to_global_id.to_s)
    end
  end

  context 'with a crater jwt impersonating a nonexistent user' do
    before do
      nonexistent_gid = "gid://sagittarius/User/#{User.maximum(:id).to_i + 1}"
      post_graphql query, headers: { authorization: "Crater #{jwt(secret, sub: nonexistent_gid)}" }
    end

    it 'does not authenticate' do
      expect(graphql_data_at(:namespace)).to be_nil
    end
  end

  context 'with a crater jwt whose sub is not a well-formed GlobalID' do
    before do
      post_graphql query, headers: { authorization: "Crater #{jwt(secret, sub: 'not-a-global-id')}" }
    end

    it 'does not authenticate' do
      expect(graphql_data_at(:namespace)).to be_nil
    end
  end

  context 'with a crater jwt whose sub names a non-User GlobalID' do
    before do
      post_graphql query, headers: { authorization: "Crater #{jwt(secret, sub: namespace.to_global_id.to_s)}" }
    end

    it 'does not authenticate' do
      expect(graphql_data_at(:namespace)).to be_nil
    end
  end

  context 'with a crater jwt impersonating a user, checking namespace ownership' do
    let(:impersonated_user) { create(:user) }
    let(:query) do
      <<~QUERY
        query {
          namespace(id: "#{namespace.to_global_id}") {
            userAbilities {
              readNamespaceOwnership
            }
          }
        }
      QUERY
    end

    before { create(:namespace_member, namespace: namespace, user: impersonated_user) }

    def request!
      post_graphql query, headers: { authorization: "Crater #{jwt(secret, sub: impersonated_user.to_global_id.to_s)}" }
    end

    context 'when the impersonated user is only a plain member' do
      it 'reports readNamespaceOwnership as false' do
        request!

        expect(graphql_data_at(:namespace, :userAbilities, :readNamespaceOwnership)).to be false
      end
    end

    context 'when the impersonated user holds a namespace_administrator role' do
      before do
        role = create(:namespace_role, namespace: namespace)
        create(:namespace_role_ability, namespace_role: role, ability: :namespace_administrator)
        impersonated_user.namespace_memberships.find_by(namespace: namespace).roles << role
      end

      it 'reports readNamespaceOwnership as true' do
        request!

        expect(graphql_data_at(:namespace, :userAbilities, :readNamespaceOwnership)).to be true
      end

      it 'never grants crater the namespace_administrator ability itself' do
        auth = Sagittarius::Authentication.new(
          :crater, CLOUD::ApplicationController::CraterToken.new(user: impersonated_user)
        )

        expect(Ability.allowed?(auth, :namespace_administrator, namespace)).to be false
      end
    end
  end

  context 'with a crater jwt impersonating a blocked user' do
    let(:impersonated_user) { create(:user, :blocked) }

    before do
      create(:namespace_member, namespace: namespace, user: impersonated_user)
      post_graphql query, headers: { authorization: "Crater #{jwt(secret, sub: impersonated_user.to_global_id.to_s)}" }
    end

    it 'does not authenticate' do
      expect(graphql_data_at(:namespace)).to be_nil
    end
  end
end
