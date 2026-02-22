# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReferenceValue do
  subject(:reference_value) do
    create(:reference_value, node_function: create(:node_function))
  end

  describe 'associations' do
    it { is_expected.to belong_to(:node_function).optional }
    it { is_expected.to have_many(:reference_paths) }
  end

  describe 'validations' do
    describe 'validate_indexes' do
      it do
        reference_value.parameter_index = 1
        is_expected.not_to be_valid
      end

      it do
        reference_value.input_index = 1
        is_expected.not_to be_valid
      end

      it do
        reference_value.parameter_index = 1
        reference_value.input_index = 1
        is_expected.to be_valid
      end

      it do
        is_expected.to be_valid
      end
    end
  end
end
