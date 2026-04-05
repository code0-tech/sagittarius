# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeFunctionDefinition do
  subject(:function) { create(:runtime_function_definition) }

  describe 'validations' do
    it { is_expected.to have_many(:parameters).inverse_of(:runtime_function_definition) }

    it { is_expected.to validate_presence_of(:runtime_name) }
    it { is_expected.to validate_uniqueness_of(:runtime_name).case_insensitive.scoped_to(:runtime_id) }
    it { is_expected.to validate_length_of(:runtime_name).is_at_most(50) }

    it { is_expected.to validate_presence_of(:signature) }
    it { is_expected.to validate_length_of(:signature).is_at_most(500) }

    it { is_expected.to validate_length_of(:definition_source).is_at_most(50) }
    it { is_expected.to validate_length_of(:display_icon).is_at_most(100) }

    describe '#validate_version' do
      it 'adds an error if version is blank' do
        function.version = ''
        function.validate_version
        expect(function.errors.added?(:version, :blank)).to be(true)
      end

      it 'adds an error if version is invalid' do
        function.version = 'invalid_version'
        function.validate_version
        expect(function.errors.added?(:version, :invalid)).to be(true)
      end

      it 'does not add an error if version is valid' do
        function.version = '1.0.0'
        function.validate_version
        expect(function.errors[:version]).to be_empty
      end
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:runtime) }

    it do
      is_expected.to have_many(:parameters)
        .class_name('RuntimeParameterDefinition')
        .inverse_of(:runtime_function_definition)
    end

    it do
      is_expected.to have_many(:runtime_function_definition_data_type_links).inverse_of(:runtime_function_definition)
    end

    it do
      is_expected.to have_many(:referenced_data_types)
        .through(:runtime_function_definition_data_type_links)
        .source(:referenced_data_type)
    end

    it { is_expected.to have_many(:names).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:descriptions).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:documentations).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:deprecation_messages).class_name('Translation').inverse_of(:owner) }
  end

  describe '#to_grpc' do
    let!(:param) { create(:runtime_parameter_definition, runtime_function_definition: function) }
    let!(:name) { create(:translation, owner: function, purpose: :name, code: 'en', content: 'Name') }
    let!(:description) { create(:translation, owner: function, purpose: :description, code: 'en', content: 'Desc') }
    let!(:documentation) { create(:translation, owner: function, purpose: :documentation, code: 'en', content: 'Doc') }
    let!(:deprecation) do
      create(:translation, owner: function, purpose: :deprecation_message, code: 'en', content: 'Dep')
    end
    let!(:display) { create(:translation, owner: function, purpose: :display_message, code: 'en', content: 'Disp') }
    let!(:alias_t) { create(:translation, owner: function, purpose: :alias, code: 'en', content: 'Ali') }
    let!(:data_type) { create(:data_type, runtime: function.runtime) }

    before do
      create(:runtime_function_definition_data_type_link,
             runtime_function_definition: function, referenced_data_type: data_type)
    end

    it 'matches the model' do
      grpc_object = function.to_grpc

      expect(grpc_object.to_h).to eq(
        runtime_name: function.runtime_name,
        runtime_parameter_definitions: [param.to_grpc.to_h],
        signature: function.signature,
        throws_error: function.throws_error,
        name: [name.to_grpc.to_h],
        description: [description.to_grpc.to_h],
        documentation: [documentation.to_grpc.to_h],
        deprecation_message: [deprecation.to_grpc.to_h],
        display_message: [display.to_grpc.to_h],
        alias: [alias_t.to_grpc.to_h],
        linked_data_type_identifiers: [data_type.identifier],
        version: function.version,
        definition_source: 'sagittarius'
      )
    end
  end
end
