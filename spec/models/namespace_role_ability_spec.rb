# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceRoleAbility do
  subject { create(:namespace_role_ability, ability: :create_namespace_role) }

  describe 'associations' do
    it { is_expected.to belong_to(:namespace_role).required }
  end

  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:ability).ignoring_case_sensitivity.scoped_to(:namespace_role_id) }
    it { is_expected.to allow_values(*described_class::ABILITIES.keys).for(:ability) }
  end
end
