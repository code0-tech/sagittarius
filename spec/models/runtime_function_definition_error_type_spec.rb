# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeFunctionDefinitionErrorType do
  describe 'associations' do
    it { is_expected.to belong_to(:runtime_function_definition) }
    it { is_expected.to belong_to(:data_type) }
  end
end
