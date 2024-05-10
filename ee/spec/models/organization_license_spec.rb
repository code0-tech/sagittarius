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
end
