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
end
