# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TeamMember do
  subject { create(:team_member) }

  describe 'associations' do
    it { is_expected.to belong_to(:team).required }
    it { is_expected.to belong_to(:user).required }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:team).scoped_to(:user_id) }
  end
end
