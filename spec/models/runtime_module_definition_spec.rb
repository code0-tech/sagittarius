# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeModuleDefinition do
  subject(:runtime_module_definition) { create(:runtime_module_definition) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime_module).inverse_of(:runtime_module_definitions) }

    it {
      is_expected.to have_many(:runtime_module_definition_flow_type_links).inverse_of(:runtime_module_definition)
    }

    it { is_expected.to have_many(:flow_types).through(:runtime_module_definition_flow_type_links) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:host) }
    it { is_expected.to validate_presence_of(:endpoint) }
    it { is_expected.to validate_presence_of(:protocol) }
    it { is_expected.to validate_length_of(:protocol).is_at_most(255) }

    it {
      is_expected.to validate_numericality_of(:port)
        .only_integer
        .is_greater_than_or_equal_to(0)
        .is_less_than_or_equal_to(65_535)
    }
  end
end
