# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeModuleStatus do
  subject(:runtime_module_status) { create(:runtime_module_status) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime_module).inverse_of(:runtime_module_status) }
  end

  describe '#uptimes' do
    it 'returns 14 daily percentages' do
      expect(runtime_module_status.uptimes.size).to eq(14)
    end
  end
end
