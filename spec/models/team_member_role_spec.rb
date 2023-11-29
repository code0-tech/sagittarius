# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamMemberRole do
  subject { create(:team_member_role) }

  describe 'associations' do
    it { is_expected.to belong_to(:team_member).inverse_of(:team_member_roles).required }
    it { is_expected.to belong_to(:role).inverse_of(:team_member_roles).required }
  end
end
