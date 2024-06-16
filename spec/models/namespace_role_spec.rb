# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceRole do
  subject { create(:namespace_role) }

  describe 'associations' do
    it { is_expected.to belong_to(:namespace).required }
    it { is_expected.to have_many(:member_roles).class_name('NamespaceMemberRole').inverse_of(:role) }
    it { is_expected.to have_many(:members).class_name('NamespaceMember').through(:member_roles).inverse_of(:roles) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:namespace_id) }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
  end
end
