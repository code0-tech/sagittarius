# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceMember do
  subject { create(:namespace_member) }

  describe 'associations' do
    it { is_expected.to belong_to(:namespace).required }
    it { is_expected.to belong_to(:user).required }

    it {
      is_expected.to have_many(:namespace_member_roles).class_name('NamespaceMemberRole').inverse_of(:namespace_member)
    }

    it {
      is_expected.to have_many(:namespace_roles).class_name('NamespaceRole').through(:namespace_member_roles)
                                                .inverse_of(:namespace_members)
    }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:namespace).scoped_to(:user_id) }
  end
end
