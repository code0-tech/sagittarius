# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceProjectRuntimeAssignment do
  subject { create(:namespace_project_runtime_assignment) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime).inverse_of(:project_assignments) }
    it { is_expected.to belong_to(:namespace_project).inverse_of(:runtime_assignments) }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:runtime).scoped_to(:namespace_project_id) }
  end
end
