# frozen_string_literal: true

RSpec.describe NamespacePolicy do
  subject { described_class.new(create_authentication(current_user), namespace) }

  context 'when user is member of the namespace' do
    let(:current_user) { create(:user) }
    let(:namespace) do
      create(:namespace).tap do |namespace|
        create(:namespace_member, namespace: namespace, user: current_user)
      end
    end

    it { is_expected.to be_allowed(:read_namespace) }
    it { is_expected.to be_allowed(:read_namespace_member) }
    it { is_expected.to be_allowed(:read_namespace_member_role) }
    it { is_expected.to be_allowed(:read_namespace_role) }
  end

  context 'when user is not member of the namespace' do
    let(:current_user) { create(:user) }
    let(:namespace) { create(:namespace) }

    it { is_expected.not_to be_allowed(:read_namespace) }
    it { is_expected.not_to be_allowed(:read_namespace_member) }
    it { is_expected.not_to be_allowed(:read_namespace_member_role) }
    it { is_expected.not_to be_allowed(:read_namespace_role) }
  end

  context 'when user is nil' do
    let(:current_user) { nil }
    let(:namespace) { create(:namespace) }

    it { is_expected.not_to be_allowed(:read_namespace) }
    it { is_expected.not_to be_allowed(:read_namespace_member) }
    it { is_expected.not_to be_allowed(:read_namespace_member_role) }
    it { is_expected.not_to be_allowed(:read_namespace_role) }
  end
end
