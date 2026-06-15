# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlowTypeSetting do
  subject { create(:flow_type_setting) }

  describe 'associations' do
    it { is_expected.to belong_to(:flow_type).inverse_of(:flow_type_settings) }
    it { is_expected.to have_many(:names).class_name('Translation') }
    it { is_expected.to have_many(:descriptions).class_name('Translation') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:identifier) }
    it { is_expected.to validate_uniqueness_of(:identifier).scoped_to(:flow_type_id) }
    it { is_expected.to allow_values(:none, :project, 'none', 'project').for(:unique) }
    it { is_expected.not_to allow_value(:unknown, 'unknown', 0).for(:unique) }
    it { is_expected.to allow_values(true, false).for(:optional) }
    it { is_expected.to allow_values(true, false).for(:hidden) }
  end

  describe 'scopes' do
    let!(:active_setting) { create(:flow_type_setting, removed_at: nil) }
    let!(:removed_setting) { create(:flow_type_setting, removed_at: Time.zone.now) }

    it 'returns active settings' do
      expect(described_class.active).to include(active_setting)
      expect(described_class.active).not_to include(removed_setting)
    end

    it 'returns removed settings' do
      expect(described_class.removed).to include(removed_setting)
      expect(described_class.removed).not_to include(active_setting)
    end
  end

  describe '#to_grpc' do
    let(:setting) do
      create(
        :flow_type_setting,
        identifier: 'HTTP_URL',
        unique: :project,
        default_value: '/status',
        optional: true,
        hidden: true
      )
    end

    it 'returns a shared flow type setting definition' do
      grpc_object = setting.to_grpc

      expect(grpc_object).to be_a(Tucana::Shared::FlowTypeSetting)
      expect(grpc_object.to_h).to include(
        identifier: 'HTTP_URL',
        unique: :PROJECT,
        default_value: {
          string_value: '/status',
        },
        optional: true,
        hidden: true
      )
    end
  end
end
