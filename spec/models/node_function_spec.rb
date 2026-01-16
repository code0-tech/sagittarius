# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NodeFunction do
  subject { create(:node_function) }

  describe 'associations' do
    it { is_expected.to belong_to(:function_definition).class_name('FunctionDefinition') }
    it { is_expected.to belong_to(:next_node).class_name('NodeFunction').optional }
    it { is_expected.to belong_to(:flow).class_name('Flow') }

    it { is_expected.to have_many(:node_parameter_values).inverse_of(:function_value) }
    it { is_expected.to have_many(:node_parameters).inverse_of(:node_function) }
  end
end
