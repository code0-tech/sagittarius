# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationLicense do
  subject(:organization_license) { build(:organization_license) }

  describe 'associations' do
    it { is_expected.to belong_to(:organization).required }
  end

  describe 'validations' do
    it 'loads license with code0-license' do
      allow(Code0::License).to receive(:load)

      organization_license.valid?

      expect(Code0::License).to have_received(:load).with(organization_license.data)
    end

    context 'when loaded license is nil' do
      subject(:organization_license) { build(:organization_license, data: '') }

      it { is_expected.not_to be_valid }
    end

    context 'when loaded license is invalid' do
      subject(:organization_license) { build(:organization_license, licensee: {}) }

      it { is_expected.not_to be_valid }
    end
  end

  describe '#license' do
    it 'memoizes loaded license' do
      allow(Code0::License).to receive(:load).and_return(SecureRandom.hex, SecureRandom.hex)

      loaded = organization_license.license

      expect(organization_license.license).to be loaded
      expect(Code0::License).to have_received(:load)
    end
  end

  describe '.current' do
    let(:first_license) { create(:organization_license) }
    let(:second_license) { create(:organization_license) }

    after do
      described_class.clear_memoize(:current)
      described_class.clear_memoize(:current_reset_on_change)
    end

    it 'memoizes license' do
      allow(described_class).to receive(:load_license)

      described_class.current(first_license.organization)
      described_class.current(first_license.organization) # make a memoized call

      expect(described_class).to have_received(:load_license)
    end

    it 'does not memoize license from wrong organization' do
      expect(described_class.current(first_license.organization)).to eq(first_license)
      expect(described_class.current(second_license.organization)).to eq(second_license)
    end
  end

  describe '.load_license' do
    let(:organization) { create(:organization) }

    it 'returns newest license' do
      create(:organization_license, organization: organization)
      current_license = create(:organization_license, organization: organization)

      expect(described_class.load_license(organization)).to eq(current_license)
    end

    it 'ignores future licenses' do
      current_license = create(:organization_license, organization: organization)
      create(
        :organization_license,
        organization: organization,
        start_date: Time.zone.today + 1,
        end_date: Time.zone.today + 2
      )

      expect(described_class.load_license(organization)).to eq(current_license)
    end
  end
end
