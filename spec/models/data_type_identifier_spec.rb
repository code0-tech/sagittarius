# frozen_string_literal: true

# spec/models/data_type_identifier_spec.rb
require 'rails_helper'

RSpec.describe DataTypeIdentifier do
  describe 'associations' do
    it { is_expected.to belong_to(:data_type).optional }
    it { is_expected.to belong_to(:generic_type).optional }
    it { is_expected.to belong_to(:runtime) }
    it { is_expected.to have_many(:generic_mappers).inverse_of(:source) }
    it { is_expected.to have_many(:function_generic_mappers).inverse_of(:source) }
  end

  describe 'validations' do
    it 'is valid with exactly one of generic_key, data_type_id, or generic_type_id' do
      expect(build(:data_type_identifier, generic_key: 'key')).to be_valid
      expect(build(:data_type_identifier, data_type: create(:data_type))).to be_valid
      generic_type = create(:generic_type, data_type: create(:data_type))
      expect(build(:data_type_identifier,
                   generic_type: generic_type)).to be_valid
    end

    it 'is invalid when none of generic_key, data_type_id, or generic_type_id are set' do
      dti = build(:data_type_identifier, generic_key: nil, data_type: nil, generic_type: nil)
      expect(dti).not_to be_valid
      expect(dti.errors[:base])
        .to include('Exactly one of generic_key, data_type_id, or generic_type_id must be present')
    end

    it 'is invalid when more than one of generic_key, data_type_id, or generic_type_id are set' do
      dti = build(:data_type_identifier, generic_key: 'key', data_type: create(:data_type))
      expect(dti).not_to be_valid
      expect(dti.errors[:base])
        .to include('Exactly one of generic_key, data_type_id, or generic_type_id must be present')
    end
  end
end
