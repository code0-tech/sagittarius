# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlowType do
  subject { create(:flow_type) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime) }
    it { is_expected.to belong_to(:input_type).class_name('DataType').optional }
    it { is_expected.to belong_to(:return_type).class_name('DataType').optional }
    it { is_expected.to have_many(:flow_type_settings).inverse_of(:flow_type) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:identifier) }
    it { is_expected.to validate_uniqueness_of(:identifier).scoped_to(:runtime_id) }
    it { is_expected.to allow_values(true, false).for(:editable) }
  end
end
