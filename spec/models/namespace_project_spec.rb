# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceProject do
  subject(:project) { create(:namespace_project) }

  describe 'associations' do
    it { is_expected.to belong_to(:namespace).required }
    it { is_expected.to have_many(:role_assignments).class_name('NamespaceRoleProjectAssignment').inverse_of(:project) }

    it do
      is_expected.to have_many(:assigned_roles).class_name('NamespaceRole')
                                               .through(:role_assignments)
                                               .source(:project)
                                               .inverse_of(:assigned_projects)
      is_expected.to have_many(:flows).class_name('Flow').inverse_of(:project)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:namespace_id) }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
    it { is_expected.to validate_length_of(:description).is_at_most(500) }
    it { is_expected.to allow_value(' ').for(:description) }
    it { is_expected.to allow_value('').for(:description) }
    it { is_expected.not_to allow_value(nil).for(:description) }

    it 'detects invalid primary runtime namespace' do
      runtime = create(:runtime, namespace: create(:namespace))
      project.primary_runtime = runtime
      is_expected.not_to be_valid
      expect(project.errors[:primary_runtime]).to include('must belong to the same namespace as the project')
    end

    it 'allows primary runtime namespace to be nil' do
      runtime = create(:runtime, namespace: nil)
      project.primary_runtime = runtime
      is_expected.to be_valid
    end
  end
end
