# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserIdentity do
  subject { create(:user_identity) }

  describe 'associations' do
    it { is_expected.to belong_to(:user).required }
  end
end
