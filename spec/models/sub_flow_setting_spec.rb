# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubFlowSetting do
  subject { create(:sub_flow_setting) }

  describe 'associations' do
    it { is_expected.to belong_to(:sub_flow).inverse_of(:sub_flow_settings) }
  end

  describe 'validations' do
    it { is_expected.to allow_values(true, false).for(:optional) }
    it { is_expected.to allow_values(true, false).for(:hidden) }
    it { is_expected.to validate_presence_of(:identifier) }
  end
end
