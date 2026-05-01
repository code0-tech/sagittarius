# frozen_string_literal: true

require 'rails_helper'

RSpec.describe License do
  it { is_expected.to include_module(CLOUD::License) }

  describe 'associations' do
    it { is_expected.to belong_to(:namespace).required }
  end

  describe '.current' do
    let(:first_license) { create(:license) }
    let(:second_license) { create(:license) }

    after do
      described_class.clear_memoize(:current_for_namespace)
      described_class.clear_memoize(:current_for_namespace_reset_on_change)
    end

    it 'memoizes license' do
      allow(described_class).to receive(:load_license_for_namespace)

      described_class.current_for_namespace(first_license.namespace)
      described_class.current_for_namespace(first_license.namespace) # make a memoized call

      expect(described_class).to have_received(:load_license_for_namespace)
    end

    it 'does not memoize license from wrong namespace' do
      expect(described_class.current_for_namespace(first_license.namespace)).to eq(first_license)
      expect(described_class.current_for_namespace(second_license.namespace)).to eq(second_license)
    end
  end

  describe '.load_license' do
    let(:namespace) { create(:namespace) }

    it 'returns newest license' do
      create(:license, namespace: namespace)
      current_license = create(:license, namespace: namespace)

      expect(described_class.load_license_for_namespace(namespace)).to eq(current_license)
    end

    it 'ignores future licenses' do
      current_license = create(:license, namespace: namespace)
      create(
        :license,
        namespace: namespace,
        start_date: Time.zone.today + 2,
        end_date: Time.zone.today + 3
      )

      expect(described_class.load_license_for_namespace(namespace)).to eq(current_license)
    end
  end
end
