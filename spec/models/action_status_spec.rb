# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActionStatus do
  subject(:action_status) { create(:action_status) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime).inverse_of(:action_statuses) }
    it { is_expected.to have_many(:action_status_configurations).inverse_of(:action_status) }
  end

  describe '#configurations' do
    it 'returns action status configurations' do
      configuration = create(:action_status_configuration, action_status: action_status)

      expect(action_status.configurations).to contain_exactly(configuration)
    end
  end
end
