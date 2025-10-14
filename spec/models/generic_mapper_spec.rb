# frozen_string_literal: true

# spec/models/generic_mapper_spec.rb
require 'rails_helper'

RSpec.describe GenericMapper do
  describe 'associations' do
    it { is_expected.to belong_to(:generic_type).optional }
    it { is_expected.to belong_to(:runtime) }
    it { is_expected.to have_many(:sources).class_name('DataTypeIdentifier').inverse_of(:generic_mapper) }

    it {
      is_expected.to have_many(:generic_combination_strategies)
        .class_name('GenericCombinationStrategy').inverse_of(:generic_mapper)
    }
  end
end
