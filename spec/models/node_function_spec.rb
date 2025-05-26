# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NodeFunction do
  subject { create(:node_function) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime_function).class_name('RuntimeFunctionDefinition') }
    it { is_expected.to belong_to(:next_node).class_name('NodeFunction').optional }

    it { is_expected.to have_many(:node_parameters).inverse_of(:function_value) }
  end
end
