# frozen_string_literal: true

RSpec.describe OrganizationMembers::InviteService do
  subject(:service_response) { described_class.new(current_user, organization, user).execute }

  let(:current_user) { create(:user) }
  let(:organization) { create(:organization) }
  let(:user) { create(:user) }

  it { expect(described_class).to include_module(EE::OrganizationMembers::InviteService) }

  context 'when user limit of license is reached' do
    before do
      create(:organization_license, organization: organization, restrictions: { user_count: 1 })
      create(:organization_member, organization: organization, user: current_user)
      stub_allowed_ability(OrganizationPolicy, :invite_member, user: current_user, subject: organization)
    end

    it { is_expected.not_to be_success }
    it { expect { service_response }.not_to change { OrganizationMember.count } }
    it { expect(service_response.payload).to eq(:no_free_license_seats) }
  end
end
