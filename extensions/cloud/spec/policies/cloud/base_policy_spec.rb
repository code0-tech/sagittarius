# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BasePolicy do
  it { expect(described_class).to include_module(CLOUD::BasePolicy) }

  describe 'crater_login authentication' do
    subject(:policy) { UserPolicy.new(authentication, user) }

    let(:user) { create(:user) }

    let(:authentication) do
      Sagittarius::Authentication.new(
        :crater_login,
        CLOUD::ApplicationController::CraterLoginToken.new(user: user)
      )
    end

    it { is_expected.to be_allowed(:read_user) }
    it { is_expected.not_to be_allowed(:update_user) }
    it { is_expected.not_to be_allowed(:delete_user) }
  end

  describe 'crater authentication' do
    subject(:policy) { UserPolicy.new(authentication, crater_user) }

    let(:crater_user) { create(:user, :crater) }

    let(:authentication) do
      Sagittarius::Authentication.new(
        :crater,
        CLOUD::ApplicationController::CraterToken.new(user: crater_user)
      )
    end

    it { is_expected.not_to be_allowed(:read_user) }
    it { is_expected.not_to be_allowed(:update_user) }
    it { is_expected.not_to be_allowed(:delete_user) }
  end

  describe 'crater authentication on a namespace' do
    subject(:policy) { NamespacePolicy.new(authentication, namespace) }

    let(:crater_user) { create(:user, :crater) }
    let(:namespace) { create(:namespace) }

    let(:authentication) do
      Sagittarius::Authentication.new(
        :crater,
        CLOUD::ApplicationController::CraterToken.new(user: crater_user)
      )
    end

    it { is_expected.to be_allowed(:read_namespace) }
    it { is_expected.to be_allowed(:read_license) }
    it { is_expected.to be_allowed(:create_license) }
    it { is_expected.to be_allowed(:delete_license) }
    it { is_expected.not_to be_allowed(:namespace_administrator) }
  end
end
