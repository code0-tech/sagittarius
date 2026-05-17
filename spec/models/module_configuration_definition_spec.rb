# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ModuleConfigurationDefinition do
  subject(:configuration_definition) { create(:module_configuration_definition) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime_module).inverse_of(:module_configuration_definitions) }

    it do
      is_expected.to have_many(:module_configuration_definition_data_type_links)
        .inverse_of(:module_configuration_definition)
    end

    it do
      is_expected.to have_many(:referenced_data_types)
        .through(:module_configuration_definition_data_type_links)
        .source(:referenced_data_type)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:identifier) }
    it { is_expected.to validate_length_of(:identifier).is_at_most(50) }
    it { is_expected.to validate_uniqueness_of(:identifier).scoped_to(:runtime_module_id) }
    it { is_expected.to validate_presence_of(:type) }
    it { is_expected.to validate_length_of(:type).is_at_most(2000) }
    it { is_expected.to allow_values(true, false).for(:optional) }
    it { is_expected.to allow_values(true, false).for(:hidden) }
  end
end
