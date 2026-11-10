# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespace do
  subject(:namespace) { create(:namespace, parent: parent) }

  let(:parent) { create(:organization) }

  describe 'associations' do
    it { is_expected.to belong_to(:parent).required }
    it { is_expected.to have_many(:namespace_members).inverse_of(:namespace) }
    it { is_expected.to have_many(:roles).inverse_of(:namespace) }
    it { is_expected.to have_many(:users).through(:namespace_members).inverse_of(:namespaces) }
    it { is_expected.to have_many(:user_namespace_pins).inverse_of(:namespace) }
  end

  describe '#organization_type?' do
    context 'when parent is organization' do
      it { expect(namespace.organization_type?).to be true }
    end

    context 'when parent is user' do
      let(:parent) { create(:user) }

      it { expect(namespace.organization_type?).to be false }
    end
  end

  describe '#member?' do
    let(:namespace) { create(:namespace) }
    let(:user) { create(:user) }

    before { create(:namespace_member, namespace: namespace, user: user) }

    it 'performs a query if members are not loaded' do
      expect { namespace.member?(user) }.to match_query_count(1)
    end

    it 'performs no query if members are loaded' do
      namespace.namespace_members.load

      expect { namespace.member?(user) }.to match_query_count(0)
    end
  end

  describe '#administrator_users' do
    let(:namespace) { create(:namespace) }

    def add_member(user, administrator:)
      member = create(:namespace_member, namespace: namespace, user: user)
      role = create(:namespace_role, namespace: namespace)
      create(:namespace_role_ability, namespace_role: role, ability: :namespace_administrator) if administrator
      create(:namespace_member_role, role: role, member: member)
    end

    it 'finds the members holding the administrator ability' do
      administrator = create(:user)
      add_member(administrator, administrator: true)
      add_member(create(:user), administrator: false)

      expect(namespace.administrator_users).to contain_exactly(administrator)
    end

    it 'leaves instance administrators out - they administer the installation, not the namespace' do
      create(:user, admin: true)

      expect(namespace.administrator_users).to be_empty
    end

    context 'with a personal namespace' do
      let(:owner) { create(:user) }
      let(:namespace) { owner.ensure_namespace }

      it 'includes the owner, who holds the ability implicitly' do
        expect(namespace.administrator_users).to include(owner)
      end
    end
  end

  describe 'personal namespace administrator via ensure_namespace' do
    let(:user) { create(:user) }

    it 'adds the owner as an administrator member' do
      namespace = user.ensure_namespace

      owner_member = namespace.namespace_members.find_by(user: user)
      administrator_role = namespace.roles
                                    .joins(:abilities)
                                    .find_by(namespace_role_abilities: { ability: :namespace_administrator })

      expect(owner_member).to be_present
      expect(owner_member.roles).to include(administrator_role)
    end
  end
end
