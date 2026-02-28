# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Runtime do
  subject { create(:runtime) }

  describe 'associations' do
    it { is_expected.to belong_to(:namespace).optional }
    it { is_expected.to have_many(:data_types).inverse_of(:runtime) }
    it { is_expected.to have_many(:data_type_identifiers).inverse_of(:runtime) }
    it { is_expected.to have_many(:generic_mappers).inverse_of(:runtime) }
    it { is_expected.to have_many(:flow_types).inverse_of(:runtime) }

    it {
      is_expected.to have_many(:project_assignments).class_name('NamespaceProjectRuntimeAssignment')
                                                    .inverse_of(:runtime)
    }

    it {
      is_expected.to have_many(:projects).class_name('NamespaceProject').through(:project_assignments)
                                         .inverse_of(:runtimes)
    }

    it { is_expected.to have_many(:runtime_statuses).inverse_of(:runtime) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:namespace_id) }
    it { is_expected.to validate_length_of(:name).is_at_most(50) }
    it { is_expected.to validate_length_of(:description).is_at_most(500) }
    it { is_expected.to allow_value(' ').for(:description) }
    it { is_expected.to allow_value('').for(:description) }
    it { is_expected.not_to allow_value(nil).for(:description) }
    it { is_expected.to validate_presence_of(:token) }
    it { is_expected.to validate_uniqueness_of(:token) }
  end
end
