# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParameterDefinition do
  subject do
    create(:parameter_definition,
           runtime_parameter_definition: create(:runtime_parameter_definition, data_type: data_type_identifier),
           data_type: data_type_identifier)
  end

  let(:data_type_identifier) { create(:data_type_identifier, generic_key: 'T') }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime_parameter_definition) }
    it { is_expected.to belong_to(:data_type) }
    it { is_expected.to have_many(:names).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:descriptions).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:documentations).class_name('Translation').inverse_of(:owner) }
  end
end
