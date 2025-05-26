# frozen_string_literal: true

# spec/models/generic_mapper_spec.rb
require 'rails_helper'

RSpec.describe GenericMapper do
  describe 'associations' do
    it { is_expected.to belong_to(:generic_type).optional }
    it { is_expected.to belong_to(:runtime) }
    it { is_expected.to belong_to(:data_type_identifier).optional }
  end

  describe 'validations' do
    it 'is valid with target and exactly one of generic_key or data_type_identifier' do
      dti = create(:data_type_identifier, generic_key: 'key')
      generic_type = create(:generic_type, data_type_identifier: dti)

      expect(build(:generic_mapper, target: 'target', generic_key: 'key1', generic_type: generic_type)).to be_valid
      expect(build(:generic_mapper, target: 'target', data_type_identifier: dti,
                                    generic_type: generic_type)).to be_valid
    end

    it 'is invalid without a target' do
      dti = create(:data_type_identifier, generic_key: 'key')
      generic_type = create(:generic_type, data_type_identifier: dti)
      gm = build(:generic_mapper, target: nil, generic_key: 'key1', generic_type: generic_type)
      expect(gm).not_to be_valid
      expect(gm.errors[:target]).to include("can't be blank")
    end

    it 'is invalid when neither generic_key nor data_type_identifier is set' do
      dti = create(:data_type_identifier, generic_key: 'key')
      generic_type = create(:generic_type, data_type_identifier: dti)
      gm = build(:generic_mapper, target: 'target', generic_key: nil, data_type_identifier: nil,
                                  generic_type: generic_type)
      expect(gm).not_to be_valid
      expect(gm.errors[:base]).to include('Exactly one of generic_key or data_type_identifier must be present')
    end

    it 'is invalid when both generic_key and data_type_identifier are set' do
      dti = create(:data_type_identifier, generic_key: 'key')
      generic_type = create(:generic_type, data_type_identifier: dti)
      gm = build(:generic_mapper, target: 'target', generic_key: 'key1', data_type_identifier: dti,
                                  generic_type: generic_type)
      expect(gm).not_to be_valid
      expect(gm.errors[:base]).to include('Exactly one of generic_key or data_type_identifier must be present')
    end
  end
end
