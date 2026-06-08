# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeModuleDefinition do
  subject(:runtime_module_definition) { create(:runtime_module_definition) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime_module).inverse_of(:runtime_module_definitions) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:host) }
    it { is_expected.to validate_presence_of(:endpoint) }

    it {
      is_expected.to validate_numericality_of(:port)
        .only_integer
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(65_535)
    }
  end
end
