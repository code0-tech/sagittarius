# frozen_string_literal: true

require 'rails_helper'

RSpec.describe License do
  it { is_expected.to include_module(CLOUD::License) }

  describe 'associations' do
    it { is_expected.to belong_to(:namespace).required }
  end

  describe '.current_for_namespace' do
    let(:namespace) { create(:namespace) }

    it 'returns newest license' do
      create(:license, namespace: namespace)
      current_license = create(:license, namespace: namespace)

      expect(described_class.current_for_namespace(namespace)).to eq(current_license)
    end

    it 'ignores future licenses' do
      current_license = create(:license, namespace: namespace)
      create(
        :license,
        namespace: namespace,
        start_date: Time.zone.today + 2,
        end_date: Time.zone.today + 3
      )

      expect(described_class.current_for_namespace(namespace)).to eq(current_license)
    end
  end
end
