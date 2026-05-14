# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ModuleConfigurationDefinitionDataTypeLink do
  subject { create(:module_configuration_definition_data_type_link) }

  describe 'associations' do
    it { is_expected.to belong_to(:module_configuration_definition) }
    it { is_expected.to belong_to(:referenced_data_type).class_name('DataType') }
  end
end
