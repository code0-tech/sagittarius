# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceRole do
  subject { create(:namespace_role) }

  describe 'associations' do
    it { is_expected.to belong_to(:namespace).required }

    it {
      is_expected.to have_many(:namespace_member_roles).class_name('NamespaceMemberRole').inverse_of(:namespace_role)
    }

    it {
      is_expected.to have_many(:namespace_members).class_name('NamespaceMember').through(:namespace_member_roles)
                                                  .inverse_of(:namespace_roles)
    }

    it {
      is_expected.to have_many(:namespace_role_project_assignments).class_name('NamespaceRoleProjectAssignment')
                                                                   .inverse_of(:namespace_role)
    }

    it do
      is_expected.to have_many(:namespace_projects).class_name('NamespaceProject')
                                                   .through(:namespace_role_project_assignments)
                                                   .source(:namespace_project)
                                                   .inverse_of(:namespace_roles)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:namespace_id) }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
  end
end
