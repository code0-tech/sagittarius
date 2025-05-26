# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlowSettingDefinition do
  subject { create(:flow_setting_definition) }

  describe 'associations' do
    it { is_expected.to have_many(:flow_settings).inverse_of(:definition) }
  end
end
