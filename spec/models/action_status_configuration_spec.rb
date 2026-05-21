# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActionStatusConfiguration do
  subject { create(:action_status_configuration) }

  describe 'associations' do
    it { is_expected.to belong_to(:action_status).inverse_of(:action_status_configurations) }
  end
end
