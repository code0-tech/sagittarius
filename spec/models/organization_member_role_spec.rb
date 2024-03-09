# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationMemberRole do
  subject { create(:organization_member_role) }

  describe 'associations' do
    it { is_expected.to belong_to(:role).required.inverse_of(:member_roles) }
    it { is_expected.to belong_to(:member).required.inverse_of(:member_roles) }
  end
end
