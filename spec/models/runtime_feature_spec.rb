# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeFeature do
  subject { create(:runtime_feature) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime_status).required }
    it { is_expected.to have_many(:names).class_name('Translation').inverse_of(:owner) }
    it { is_expected.to have_many(:descriptions).class_name('Translation').inverse_of(:owner) }
  end
end
