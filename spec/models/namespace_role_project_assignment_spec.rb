# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceRoleProjectAssignment do
  subject { create(:namespace_role_project_assignment) }

  describe 'associations' do
    it {
      is_expected.to belong_to(:namespace_role).class_name('NamespaceRole')
                                               .inverse_of(:namespace_role_project_assignments).required
    }

    it {
      is_expected.to belong_to(:namespace_project).class_name('NamespaceProject')
                                                  .inverse_of(:namespace_role_project_assignments).required
    }
  end
end
