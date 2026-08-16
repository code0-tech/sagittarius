# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlowTypeSetting do
  subject { create(:flow_type_setting) }

  describe 'associations' do
    it { is_expected.to belong_to(:flow_type).inverse_of(:flow_type_settings) }
    it { is_expected.to belong_to(:runtime_flow_type_setting).inverse_of(:flow_type_settings) }
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

    describe '#flow_type_matches_setting' do
      let(:runtime_flow_type) { create(:runtime_flow_type) }
      let(:other_runtime_flow_type) { create(:runtime_flow_type) }
      let(:flow_type) { create(:flow_type, runtime_flow_type: runtime_flow_type) }
      let(:runtime_flow_type_setting) { create(:runtime_flow_type_setting, runtime_flow_type: runtime_flow_type) }
      let(:other_runtime_flow_type_setting) do
        create(:runtime_flow_type_setting, runtime_flow_type: other_runtime_flow_type)
      end

      it 'is valid when runtime_flow_type_setting belongs to the same runtime_flow_type' do
        setting = build(:flow_type_setting, flow_type: flow_type, runtime_flow_type_setting: runtime_flow_type_setting)
        expect(setting).to be_valid
      end

      it 'is invalid when runtime_flow_type_setting belongs to a different runtime_flow_type' do
        setting = build(:flow_type_setting, flow_type: flow_type,
                                            runtime_flow_type_setting: other_runtime_flow_type_setting)
        expect(setting).not_to be_valid
        expect(setting.errors.added?(:flow_type, :runtime_flow_type_mismatch)).to be(true)
      end
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
