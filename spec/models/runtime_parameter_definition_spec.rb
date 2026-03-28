# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeParameterDefinition do
  subject { create(:runtime_parameter_definition) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:runtime_name) }

    it {
      is_expected.to validate_uniqueness_of(:runtime_name).case_insensitive.scoped_to(:runtime_function_definition_id)
    }

    it { is_expected.to validate_length_of(:runtime_name).is_at_most(50) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:runtime_function_definition) }
    it { is_expected.to have_many(:parameter_definitions).inverse_of(:runtime_parameter_definition) }
    it { is_expected.to have_many(:names).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:descriptions).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:documentations).class_name('Translation').inverse_of(:owner) }
  end

  describe '#to_grpc' do
    subject(:parameter) { create(:runtime_parameter_definition) }

    let!(:name) { create(:translation, owner: parameter, purpose: :name, code: 'en', content: 'Name') }
    let!(:description) { create(:translation, owner: parameter, purpose: :description, code: 'en', content: 'Desc') }
    let!(:documentation) { create(:translation, owner: parameter, purpose: :documentation, code: 'en', content: 'Doc') }

    it 'matches the model' do
      grpc_object = parameter.to_grpc

      expect(grpc_object.to_h).to eq(
        runtime_name: parameter.runtime_name,
        default_value: Tucana::Shared::Value.from_ruby(parameter.default_value).to_h,
        name: [name.to_grpc.to_h],
        description: [description.to_grpc.to_h],
        documentation: [documentation.to_grpc.to_h]
      )
    end
  end
end
