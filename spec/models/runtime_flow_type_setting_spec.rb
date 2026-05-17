# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RuntimeFlowTypeSetting do
  subject(:runtime_flow_type_setting) { create(:runtime_flow_type_setting) }

  describe 'associations' do
    it { is_expected.to belong_to(:runtime_flow_type).inverse_of(:runtime_flow_type_settings) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:identifier) }
    it { is_expected.to validate_uniqueness_of(:identifier).scoped_to(:runtime_flow_type_id) }
    it { is_expected.to validate_presence_of(:unique) }
    it { is_expected.to allow_values(true, false).for(:optional) }
    it { is_expected.to allow_values(true, false).for(:hidden) }

    it 'allows known uniqueness scopes' do
      expect(runtime_flow_type_setting).to allow_values(:none, :project).for(:unique)
    end

    it 'rejects the unknown uniqueness scope' do
      runtime_flow_type_setting.unique = :unknown
      expect(runtime_flow_type_setting).not_to be_valid
    end
  end

  describe 'scopes' do
    let!(:active_setting) { create(:runtime_flow_type_setting, removed_at: nil) }
    let!(:removed_setting) { create(:runtime_flow_type_setting, removed_at: Time.zone.now) }

    it 'returns active settings' do
      expect(described_class.active).to contain_exactly(active_setting)
    end

    it 'returns removed settings' do
      expect(described_class.removed).to contain_exactly(removed_setting)
    end
  end
end
