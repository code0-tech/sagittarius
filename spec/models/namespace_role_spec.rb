# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceRole do
  subject { create(:namespace_role) }

  describe 'associations' do
    it { is_expected.to belong_to(:namespace).required }
    it { is_expected.to have_many(:member_roles).class_name('NamespaceMemberRole').inverse_of(:role) }
    it { is_expected.to have_many(:members).class_name('NamespaceMember').through(:member_roles).inverse_of(:roles) }
    it { is_expected.to have_many(:project_assignments).class_name('NamespaceRoleProjectAssignment').inverse_of(:role) }

    it do
      is_expected.to have_many(:assigned_projects).class_name('NamespaceProject')
                                                  .through(:project_assignments)
                                                  .source(:role)
                                                  .inverse_of(:assigned_roles)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:namespace_id) }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
  end
end
