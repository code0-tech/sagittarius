# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdapterRuntimeStatus do
  subject(:adapter_runtime_status) { create(:adapter_runtime_status) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime).inverse_of(:adapter_runtime_statuses) }
    it { is_expected.to have_many(:adapter_status_configurations).inverse_of(:adapter_runtime_status) }
  end

  describe '#configurations' do
    it 'returns adapter status configurations' do
      configuration = create(:adapter_status_configuration, adapter_runtime_status: adapter_runtime_status)

      expect(adapter_runtime_status.configurations).to contain_exactly(configuration)
    end
  end
end
