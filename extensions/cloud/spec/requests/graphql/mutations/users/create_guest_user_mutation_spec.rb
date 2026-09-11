# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'usersCreateGuestUser Mutation' do
  include GraphqlHelpers

  subject(:mutate!) { post_graphql mutation, variables: variables, headers: headers }

  let(:mutation) do
    <<~QUERY
      mutation($input: UsersCreateGuestUserInput!) {
        usersCreateGuestUser(input: $input) {
          #{error_query}
          claimToken
          user {
            id
            username
          }
        }
      }
    QUERY
  end

  let(:username) { generate(:username) }
  let(:email) { generate(:email) }
  let(:variables) { { input: { username: username, email: email } } }

  let(:secret) { 'crater-secret' }
  # rubocop:disable-next RSpec/LetSetup -- needs to exist in the DB for the controller to find it
  let!(:crater_user) { create(:user, :crater) }

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

  context 'when called by crater' do
    let(:headers) { { authorization: "Crater #{jwt(secret)}" } }

    before { mutate! }

    it 'creates a guest user' do
      expect(graphql_data_at(:users_create_guest_user, :user, :username)).to eq(username)
    end

    it 'returns a claim token' do
      expect(graphql_data_at(:users_create_guest_user, :claim_token)).to be_present
    end

    it 'persists the user as a guest' do
      mutate!

      expect(User.find_by(username: username)).to be_guest
    end
  end

  context 'when called by a regular session' do
    subject(:mutate!) { post_graphql mutation, variables: variables, current_user: create(:user) }

    before { mutate! }

    it 'does not create a guest user' do
      expect(graphql_data_at(:users_create_guest_user, :user)).to be_nil
      expect(graphql_data_at(:users_create_guest_user, :errors, :error_code)).to include('MISSING_PERMISSION')
    end
  end
end
