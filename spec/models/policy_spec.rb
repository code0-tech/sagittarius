# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Policy do
  subject { create(:policy) }

  describe 'associations' do
    it { is_expected.to belong_to(:permission).inverse_of(:policies).required }
    it { is_expected.to have_many(:role_policies).inverse_of(:policy) }
  end
end
