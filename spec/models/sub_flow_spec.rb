# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubFlow do
  subject { create(:sub_flow) }

  describe 'associations' do
    it { is_expected.to belong_to(:node_parameter).inverse_of(:sub_flow) }
    it { is_expected.to belong_to(:starting_node).class_name('NodeFunction').optional }
    it { is_expected.to have_many(:sub_flow_settings).inverse_of(:sub_flow) }
  end

  describe 'validations' do
    it 'requires exactly one execution reference' do
      sub_flow = build(:sub_flow, starting_node: nil, function_identifier: nil)

      expect(sub_flow).not_to be_valid
      expect(sub_flow.errors[:base]).to include('Exactly one of starting_node or function_identifier must be present')
    end
  end
end
