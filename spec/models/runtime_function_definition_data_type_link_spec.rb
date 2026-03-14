# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeFunctionDefinitionDataTypeLink do
  subject { create(:runtime_function_definition_data_type_link) }

  describe 'associations' do
    it do
      is_expected.to belong_to(:runtime_function_definition).inverse_of(:runtime_function_definition_data_type_links)
    end

    it { is_expected.to belong_to(:referenced_data_type).class_name('DataType') }
  end
end
