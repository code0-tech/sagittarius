# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParameterDefinition do
  subject { create(:parameter_definition) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime_parameter_definition) }
    it { is_expected.to belong_to(:data_type) }
    it { is_expected.to have_many(:names).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:descriptions).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:documentations).class_name('Translation').inverse_of(:owner) }
  end
end
