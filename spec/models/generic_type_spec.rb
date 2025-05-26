# frozen_string_literal: true

# spec/models/generic_type_spec.rb
require 'rails_helper'

RSpec.describe GenericType do
  describe 'associations' do
    it { is_expected.to belong_to(:data_type_identifier) }
    it { is_expected.to belong_to(:runtime) }
    it { is_expected.to have_many(:generic_mappers) }
  end

  describe 'validations' do
    it 'is valid with a data_type_identifier' do
      dti = create(:data_type_identifier, generic_key: 'key')
      expect(build(:generic_type, data_type_identifier: dti)).to be_valid
    end

    it 'is invalid without a data_type_identifier' do
      expect(build(:generic_type, data_type_identifier: nil)).not_to be_valid
    end
  end
end
