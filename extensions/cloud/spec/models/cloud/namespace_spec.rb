# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespace do
  it { is_expected.to include_module(CLOUD::Namespace) }

  describe 'associations' do
    it { is_expected.to have_many(:licenses).inverse_of(:namespace) }
  end
end
