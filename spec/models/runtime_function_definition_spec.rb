# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeFunctionDefinition do
  subject { create(:runtime_function_definition) }

  describe 'validations' do
    it { is_expected.to have_many(:parameters).inverse_of(:runtime_function_definition) }

    it { is_expected.to validate_presence_of(:runtime_name) }
    it { is_expected.to validate_uniqueness_of(:runtime_name).case_insensitive.scoped_to(:namespace_id) }
    it { is_expected.to validate_length_of(:runtime_name).is_at_most(50) }

    it { is_expected.to validate_presence_of(:namespace) }
  end
end
