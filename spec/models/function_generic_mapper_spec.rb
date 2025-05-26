# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FunctionGenericMapper do
  describe 'associations' do
    it { is_expected.to belong_to(:data_type_identifier).optional }
    it { is_expected.to belong_to(:runtime_parameter_definition).optional }

    it {
      is_expected.to belong_to(:runtime_function_definition).class_name('RuntimeFunctionDefinition')
                                                            .optional.inverse_of(:generic_mappers)
    }
  end

  describe 'validations' do
    it 'is valid with target and one of generic_key or data_type_identifier' do
      dti = create(:data_type_identifier, generic_key: 'x')
      expect(build(:function_generic_mapper, target: 'do_something', generic_key: 'param')).to be_valid
      expect(build(:function_generic_mapper, target: 'do_something', data_type_identifier: dti)).to be_valid
    end

    it 'is invalid with both generic_key and data_type_identifier' do
      dti = create(:data_type_identifier, generic_key: 'x')
      mapper = build(:function_generic_mapper, target: 'x', generic_key: 'param', data_type_identifier: dti)
      expect(mapper).not_to be_valid
      expect(mapper.errors[:base]).to include('Exactly one of generic_key or data_type_identifier_id must be present')
    end

    it 'is invalid with neither generic_key nor data_type_identifier' do
      mapper = build(:function_generic_mapper, target: 'x', generic_key: nil, data_type_identifier: nil)
      expect(mapper).not_to be_valid
      expect(mapper.errors[:base]).to include('Exactly one of generic_key or data_type_identifier_id must be present')
    end

    it 'is invalid without a target' do
      mapper = build(:function_generic_mapper, target: nil, generic_key: 'something')
      expect(mapper).not_to be_valid
      expect(mapper.errors[:target]).to include("can't be blank")
    end
  end
end
