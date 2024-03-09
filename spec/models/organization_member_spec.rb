# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationMember do
  subject { create(:organization_member) }

  describe 'associations' do
    it { is_expected.to belong_to(:team).required }
    it { is_expected.to belong_to(:user).required }
    it { is_expected.to have_many(:member_roles).class_name('OrganizationMemberRole').inverse_of(:member) }
    it { is_expected.to have_many(:roles).class_name('OrganizationRole').through(:member_roles).inverse_of(:members) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:team).scoped_to(:user_id) }
  end
end
