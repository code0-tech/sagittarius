# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespace do
  it { is_expected.to include_module(EE::Namespace) }

  describe 'associations' do
    it { is_expected.to have_many(:namespace_licenses).inverse_of(:namespace) }
  end
end
