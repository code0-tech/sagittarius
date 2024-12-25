# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataTypeRule do
  subject { create(:data_type_rule) }

  describe 'associations' do
    it { is_expected.to belong_to(:data_type).inverse_of(:rules) }
  end

  describe 'validations' do
    it { is_expected.to allow_values(*described_class::VARIANTS.keys).for(:variant) }
  end
end
