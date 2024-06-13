# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceMember do
  subject { create(:namespace_member) }

  describe 'associations' do
    it { is_expected.to belong_to(:namespace).required }
    it { is_expected.to belong_to(:user).required }
    it { is_expected.to have_many(:member_roles).class_name('NamespaceMemberRole').inverse_of(:member) }
    it { is_expected.to have_many(:roles).class_name('NamespaceRole').through(:member_roles).inverse_of(:members) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:namespace).scoped_to(:user_id) }
  end
end
