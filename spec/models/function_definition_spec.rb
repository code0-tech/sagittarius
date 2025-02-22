# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FunctionDefinition do
  subject { create(:function_definition) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime_function_definition) }
    it { is_expected.to belong_to(:return_type).class_name('DataType').optional }
  end
end
