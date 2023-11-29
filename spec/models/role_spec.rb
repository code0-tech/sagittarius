# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role do
  subject { create(:role) }

  describe 'associations' do
    it { is_expected.to belong_to(:team).inverse_of(:roles) }
    it { is_expected.to have_many(:role_policies).inverse_of(:role) }
    it { is_expected.to have_many(:team_member_roles).inverse_of(:role) }
  end
end
