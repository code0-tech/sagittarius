# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdapterStatusConfiguration do
  subject { create(:adapter_status_configuration) }

  describe 'associations' do
    it { is_expected.to belong_to(:adapter_runtime_status).inverse_of(:adapter_status_configurations) }
  end
end
