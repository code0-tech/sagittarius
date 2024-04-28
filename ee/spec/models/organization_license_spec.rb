# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationLicense do
  subject { create(:organization_license) }

  describe 'associations' do
    it { is_expected.to belong_to(:organization).required }
  end
end
