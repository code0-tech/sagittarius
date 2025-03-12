# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceLicense do
  subject(:namespace_license) { build(:namespace_license) }

  describe 'associations' do
    it { is_expected.to belong_to(:namespace).required }
  end

  describe 'validations' do
    it 'loads license with code0-license' do
      allow(Code0::License).to receive(:load)

      namespace_license.valid?

      expect(Code0::License).to have_received(:load).with(namespace_license.data)
    end

    context 'when loaded license is nil' do
      subject(:namespace_license) { build(:namespace_license, data: '') }

      it { is_expected.not_to be_valid }
    end

    context 'when loaded license is invalid' do
      subject(:namespace_license) { build(:namespace_license, licensee: {}) }

      it { is_expected.not_to be_valid }
    end
  end

  describe '#license' do
    it 'memoizes loaded license' do
      allow(Code0::License).to receive(:load).and_return(SecureRandom.hex, SecureRandom.hex)

      loaded = namespace_license.license

      expect(namespace_license.license).to be loaded
      expect(Code0::License).to have_received(:load)
    end
  end

  describe '.current' do
    let(:first_license) { create(:namespace_license) }
    let(:second_license) { create(:namespace_license) }

    after do
      described_class.clear_memoize(:current)
      described_class.clear_memoize(:current_reset_on_change)
    end

    it 'memoizes license' do
      allow(described_class).to receive(:load_license)

      described_class.current(first_license.namespace)
      described_class.current(first_license.namespace) # make a memoized call

      expect(described_class).to have_received(:load_license)
    end

    it 'does not memoize license from wrong namespace' do
      expect(described_class.current(first_license.namespace)).to eq(first_license)
      expect(described_class.current(second_license.namespace)).to eq(second_license)
    end
  end

  describe '.load_license' do
    let(:namespace) { create(:namespace) }

    it 'returns newest license' do
      create(:namespace_license, namespace: namespace)
      current_license = create(:namespace_license, namespace: namespace)

      expect(described_class.load_license(namespace)).to eq(current_license)
    end

    it 'ignores future licenses' do
      current_license = create(:namespace_license, namespace: namespace)
      create(
        :namespace_license,
        namespace: namespace,
        start_date: Time.zone.today + 2,
        end_date: Time.zone.today + 3
      )

      expect(described_class.load_license(namespace)).to eq(current_license)
    end
  end
end
