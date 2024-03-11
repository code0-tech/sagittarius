# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationPolicy do
  subject { described_class.new(current_user, organization) }

  let(:current_user) { nil }

  context 'when user is member of the organization' do
    let(:current_user) { create(:user) }
    let(:organization) do
      create(:organization).tap do |organization|
        create(:organization_member, organization: organization, user: current_user)
      end
    end

    it { is_expected.to be_allowed(:read_organization) }
    it { is_expected.to be_allowed(:read_organization_member) }
  end

  context 'when user is not member of the organization' do
    let(:current_user) { create(:user) }
    let(:organization) { create(:organization) }

    it { is_expected.not_to be_allowed(:read_organization) }
    it { is_expected.not_to be_allowed(:read_organization_member) }
  end

  context 'when user is nil' do
    let(:current_user) { nil }
    let(:organization) { create(:organization) }

    it { is_expected.not_to be_allowed(:read_organization) }
    it { is_expected.not_to be_allowed(:read_organization_member) }
  end
end
