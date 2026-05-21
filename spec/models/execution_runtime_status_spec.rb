# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExecutionRuntimeStatus do
  subject { create(:execution_runtime_status) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime).inverse_of(:execution_runtime_statuses) }
  end
end
