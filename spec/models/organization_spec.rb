# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organization do
  subject { create(:organization) }

  describe 'associations' do
    it { is_expected.to have_many(:organization_members).inverse_of(:organization) }
    it { is_expected.to have_many(:roles).inverse_of(:organization) }
    it { is_expected.to have_many(:users).through(:organization_members).inverse_of(:organizations) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
  end

  describe '#member?' do
    let(:organization) { create(:organization) }
    let(:user) { create(:user) }

    before { create(:organization_member, organization: organization, user: user) }

    it 'performs a query if members are not loaded' do
      expect { organization.member?(user) }.to match_query_count(1)
    end

    it 'performs no query if members are loaded' do
      organization.organization_members.load

      expect { organization.member?(user) }.to match_query_count(0)
    end
  end
end
