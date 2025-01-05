# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Translation do
  subject { create(:translation) }

  describe 'associations' do
    it { is_expected.to belong_to(:owner).required }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:content) }
  end
end
