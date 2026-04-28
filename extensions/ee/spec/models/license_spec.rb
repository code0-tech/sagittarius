# frozen_string_literal: true

require 'rails_helper'

RSpec.describe License do
  subject(:license) { build(:license) }

  describe 'validations' do
    it 'loads license with code0-license' do
      allow(Code0::License).to receive(:load)

      license.valid?

      expect(Code0::License).to have_received(:load).with(license.data)
    end

    context 'when loaded license is nil' do
      subject(:license) { build(:license, data: '') }

      it { is_expected.not_to be_valid }
    end

    context 'when loaded license is invalid' do
      subject(:license) { build(:license, licensee: {}) }

      it { is_expected.not_to be_valid }
    end
  end

  describe '#license' do
    it 'memoizes loaded license' do
      allow(Code0::License).to receive(:load).and_return(SecureRandom.hex, SecureRandom.hex)

      loaded = license.license

      expect(license.license).to be loaded
      expect(Code0::License).to have_received(:load)
    end
  end
end
