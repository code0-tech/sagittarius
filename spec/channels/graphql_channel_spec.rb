# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GraphqlChannel do
  include AuthenticationHelpers

  include_context 'with graphql subscription support'

  let(:user) { create(:user) }
  let(:token) { "Session #{authorization_token(user)}" }

  describe '#subscribed' do
    context 'with valid token' do
      it 'confirms subscription' do
        subscribe(token: token)
        expect(subscription).to be_confirmed
      end
    end

    context 'with invalid token' do
      it 'rejects subscription' do
        subscribe(token: 'Session invalid')
        expect(subscription).to be_rejected
      end
    end

    context 'without token' do
      it 'rejects subscription' do
        subscribe(token: nil)
        expect(subscription).to be_rejected
      end
    end
  end

  describe '#execute' do
    before { subscribe(token: token) }

    it 'returns the initial subscription result' do
      perform :execute,
              query: 'subscription($message: String) { echo(message: $message) { message } }',
              variables: { message: 'hello' }

      expect(transmissions.last).to include(
        'result' => { 'data' => { 'echo' => { 'message' => 'hello' } } },
        'more' => true
      )
    end

    it 'receives updates when triggered' do
      variables = { message: 'hello' }
      perform :execute,
              query: 'subscription($message: String) { echo(message: $message) { message } }',
              variables: variables

      SagittariusSchema.subscriptions.trigger(:echo, variables, { message: 'updated' },
                                              context: { visibility_profile: :execution })

      expect(transmissions.last).to include(
        'result' => { 'data' => { 'echo' => { 'message' => 'updated' } } },
        'more' => true
      )
    end
  end
end
