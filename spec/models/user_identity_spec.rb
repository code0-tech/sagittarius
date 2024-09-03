# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserIdentity do
  subject { create(:user_session) }

  describe 'associations' do
    it { is_expected.to belong_to(:user).required }
  end

  describe 'validations' do

  end

end
