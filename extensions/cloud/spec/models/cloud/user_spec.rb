# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User do
  it { is_expected.to include_module(CLOUD::User) }

  describe 'crater_login token' do
    subject(:user) { create(:user) }

    it 'generates a crater_login token' do
      token = user.generate_token_for(:crater_login)
      expect(token).to be_present
    end

    it 'resolves user from token' do
      token = user.generate_token_for(:crater_login)
      expect(described_class.find_by_token_for(:crater_login, token)).to eq(user)
    end
  end

  describe '#deletion_restriction' do
    subject(:user) { create(:user) }

    context 'when user has an active_subscription custom attribute' do
      before { create(:user_custom_attribute, user: user, key: 'active_subscription', value: true) }

      it 'returns :active_subscription' do
        expect(user.deletion_restriction).to eq(:active_subscription)
      end
    end

    context 'when user does not have an active_subscription custom attribute' do
      before { create(:user, admin: true) }

      it 'falls through to the base implementation' do
        expect(user.deletion_restriction).to be_nil
      end
    end

    context 'when user has other custom attributes but not active_subscription' do
      before do
        create(:user, admin: true)
        create(:user_custom_attribute, user: user, key: 'some_other_key', value: 'some_value')
      end

      it 'falls through to the base implementation' do
        expect(user.deletion_restriction).to be_nil
      end
    end
  end
end
