# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy do
  it { expect(described_class).to include_module(CLOUD::UserPolicy) }

  describe 'crater authentication' do
    subject(:policy) { described_class.new(authentication, target_user) }

    let(:crater_user) { create(:user, :crater) }
    let(:target_user) { create(:user) }

    let(:authentication) do
      Sagittarius::Authentication.new(
        :crater,
        CLOUD::ApplicationController::CraterToken.new(user: crater_user)
      )
    end

    it { is_expected.to be_allowed(:update_user_custom_attribute) }
    it { is_expected.not_to be_allowed(:read_user) }
    it { is_expected.not_to be_allowed(:update_user) }
    it { is_expected.not_to be_allowed(:delete_user) }
  end

  describe 'session authentication' do
    subject(:policy) { described_class.new(create_authentication(current_user), target_user) }

    let(:current_user) { create(:user) }
    let(:target_user) { create(:user) }

    it { is_expected.not_to be_allowed(:update_user_custom_attribute) }
  end
end
