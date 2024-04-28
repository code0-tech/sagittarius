require 'rails_helper'

RSpec.describe Organization do

  it { is_expected.to include_module(EE::Organization) }



  describe 'associations' do
    it { is_expected.to have_many(:organization_licenses).inverse_of(:organization) }
  end
end
