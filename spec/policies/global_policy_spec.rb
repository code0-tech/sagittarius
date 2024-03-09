# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GlobalPolicy do
  subject { described_class.new(current_user, nil) }

  context 'when user is present' do
    let(:current_user) { create(:user) }

    it { is_expected.to be_allowed(:create_organization) }
    it { is_expected.not_to be_allowed(:read_application_setting) }
    it { is_expected.not_to be_allowed(:update_application_setting) }

    context 'when organization creation is restricted' do
      before do
        stub_application_settings(organization_creation_restricted: true)
      end

      it { is_expected.not_to be_allowed(:create_organization) }
    end
  end

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_allowed(:create_organization) }
    it { is_expected.not_to be_allowed(:read_application_setting) }
    it { is_expected.not_to be_allowed(:update_application_setting) }
  end

  context 'when user is admin' do
    let(:current_user) { create(:user, :admin) }

    it { is_expected.to be_allowed(:read_application_setting) }
    it { is_expected.to be_allowed(:update_application_setting) }

    context 'when organization creation is restricted' do
      before do
        stub_application_settings(organization_creation_restricted: true)
      end

      it { is_expected.to be_allowed(:create_organization) }
    end
  end
end
