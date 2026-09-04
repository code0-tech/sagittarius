# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespacePolicy do
  subject { described_class.new(create_authentication(current_user), namespace) }

  let(:namespace) { create(:namespace) }

  it { expect(described_class).to include_module(CLOUD::NamespacePolicy) }

  context 'when the current user is a crater user' do
    let(:current_user) { create(:user, :crater) }

    it { is_expected.to be_allowed(:read_namespace) }
    it { is_expected.to be_allowed(:read_license) }
    it { is_expected.to be_allowed(:create_license) }
    it { is_expected.to be_allowed(:delete_license) }

    it { is_expected.not_to be_allowed(:namespace_administrator) }
  end

  context 'when the current user is a regular user and not a member' do
    let(:current_user) { create(:user) }

    it { is_expected.not_to be_allowed(:read_namespace) }
    it { is_expected.not_to be_allowed(:read_license) }
    it { is_expected.not_to be_allowed(:create_license) }
    it { is_expected.not_to be_allowed(:delete_license) }
  end
end
