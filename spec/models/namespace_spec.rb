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
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:parent) }
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
end
