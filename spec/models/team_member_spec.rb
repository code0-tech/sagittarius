# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamMember do
  subject { create(:team_member) }

  describe 'associations' do
    it { is_expected.to belong_to(:team).inverse_of(:team_members).required }
    it { is_expected.to belong_to(:user).inverse_of(:team_members).required }
    it { is_expected.to have_many(:team_member_roles).inverse_of(:team_member) }
  end
end
