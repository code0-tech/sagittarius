# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenericCombinationStrategy do
  describe 'associations' do
    it { is_expected.to belong_to(:generic_mapper).optional }
  end

  describe 'enums' do
    it 'defines the correct enum values' do
      expect(described_class.types).to eq({
                                            'and' => 1,
                                            'or' => 2,
                                          })
    end
  end
end
