# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataType do
  subject(:data_type) { create(:data_type) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime).inverse_of(:data_types) }
    it { is_expected.to have_many(:names).class_name('Translation') }
    it { is_expected.to have_many(:aliases).class_name('Translation') }
    it { is_expected.to have_many(:display_messages).class_name('Translation') }
    it { is_expected.to have_many(:rules).class_name('DataTypeRule').inverse_of(:data_type) }
    it { is_expected.to have_many(:data_type_data_type_links).inverse_of(:data_type) }

    it do
      is_expected.to have_many(:referenced_data_types).through(:data_type_data_type_links).source(:referenced_data_type)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:type) }
    it { is_expected.to validate_length_of(:type).is_at_most(2000) }
    it { is_expected.to validate_length_of(:definition_source).is_at_most(50) }

    describe '#validate_version' do
      it 'adds an error if version is blank' do
        data_type.version = ''
        data_type.validate_version
        expect(data_type.errors.added?(:version, :blank)).to be(true)
      end

      it 'adds an error if version is invalid' do
        data_type.version = 'invalid_version'
        data_type.validate_version
        expect(data_type.errors.added?(:version, :invalid)).to be(true)
      end

      it 'does not add an error if version is valid' do
        data_type.version = '1.0.0'
        data_type.validate_version
        expect(data_type.errors[:version]).to be_empty
      end
    end
  end

  describe '#to_grpc' do
    let!(:name) { create(:translation, owner: data_type, purpose: :name, code: 'en', content: 'Name') }
    let!(:display) { create(:translation, owner: data_type, purpose: :display_message, code: 'en', content: 'Disp') }
    let!(:alias_t) { create(:translation, owner: data_type, purpose: :alias, code: 'en', content: 'Ali') }
    let!(:rule) { create(:data_type_rule, data_type: data_type) }
    let!(:ref_data_type) { create(:data_type, runtime: data_type.runtime) }

    before { create(:data_type_data_type_link, data_type: data_type, referenced_data_type: ref_data_type) }

    it 'matches the model' do
      grpc_object = data_type.to_grpc

      expect(grpc_object.to_h).to eq(
        identifier: data_type.identifier,
        name: [name.to_grpc.to_h],
        display_message: [display.to_grpc.to_h],
        alias: [alias_t.to_grpc.to_h],
        rules: [rule.to_grpc.to_h],
        type: data_type.type,
        linked_data_type_identifiers: [ref_data_type.identifier],
        version: data_type.version,
        definition_source: 'sagittarius'
      )
    end
  end
end
