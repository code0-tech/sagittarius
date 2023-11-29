# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RolePolicy do
  subject { create(:role_policy) }

  describe 'associations' do
    it { is_expected.to belong_to(:policy).inverse_of(:role_policies).required }
    it { is_expected.to belong_to(:role).inverse_of(:role_policies).required }
  end
end
