# frozen_string_literal: true

RSpec.describe NamespaceMembers::InviteService do
  subject(:service_response) { described_class.new(current_user, namespace, user).execute }

  let(:current_user) { create(:user) }
  let(:namespace) { create(:namespace) }
  let(:user) { create(:user) }

  it { expect(described_class).to include_module(EE::NamespaceMembers::InviteService) }

  context 'when user limit of license is reached' do
    before do
      create(:namespace_license, namespace: namespace, restrictions: { user_count: 1 })
      create(:namespace_member, namespace: namespace, user: current_user)
      stub_allowed_ability(NamespacePolicy, :invite_member, user: current_user, subject: namespace)
    end

    it { is_expected.not_to be_success }
    it { expect { service_response }.not_to change { NamespaceMember.count } }
    it { expect(service_response.payload).to eq(:no_free_license_seats) }
  end
end
