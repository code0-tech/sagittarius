# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Flow do
  subject { create(:flow) }

  describe 'associations' do
    it { is_expected.to belong_to(:project).class_name('NamespaceProject') }
    it { is_expected.to belong_to(:flow_type) }
    it { is_expected.to belong_to(:starting_node).class_name('NodeFunction') }
    it { is_expected.to belong_to(:input_type).class_name('DataType').optional }
    it { is_expected.to belong_to(:return_type).class_name('DataType').optional }

    it { is_expected.to have_many(:flow_settings) }
  end
end
