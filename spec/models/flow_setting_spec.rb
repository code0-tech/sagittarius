# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlowSetting do
  subject { create(:flow_setting) }

  describe 'associations' do
    it { is_expected.to belong_to(:flow).optional }
  end
end
