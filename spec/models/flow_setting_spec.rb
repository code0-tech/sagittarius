# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlowSetting do
  subject { create(:flow_setting) }

  describe 'associations' do
    it { is_expected.to belong_to(:flow).optional }
  end

  describe 'validations' do
    it { is_expected.to allow_value(nil).for(:object) }

    describe 'value uniqueness within scope' do
      let(:project) { create(:namespace_project) }
      let(:flow_type) { create(:flow_type) }

      def create_flow_setting(flow:, value:)
        build(:flow_setting, flow: flow, flow_setting_id: 'webhook_path', object: value)
      end

      context 'when the flow type setting is scoped to project' do
        let(:existing_flow) { create(:flow, project: project, flow_type: flow_type) }
        let(:other_flow) { create(:flow, project: project, flow_type: flow_type) }

        before do
          create(:flow_type_setting, flow_type: flow_type, identifier: 'webhook_path', unique: :project)
          create_flow_setting(flow: existing_flow, value: { path: '/hook' }).save!
        end

        it 'rejects the same value on another flow of the same project' do
          setting = create_flow_setting(flow: other_flow, value: { path: '/hook' })

          expect(setting).not_to be_valid
          expect(setting.errors.details[:object]).to include(error: :not_unique_in_scope)
        end

        it 'allows a different value on another flow of the same project' do
          setting = create_flow_setting(flow: other_flow, value: { path: '/other' })

          expect(setting).to be_valid
        end

        it 'allows the same value on a flow of a different project' do
          other_project_flow = create(:flow, project: create(:namespace_project), flow_type: flow_type)
          setting = create_flow_setting(flow: other_project_flow, value: { path: '/hook' })

          expect(setting).to be_valid
        end

        it 'allows updating the same value on the flow that already owns it' do
          setting = existing_flow.flow_settings.find_by(flow_setting_id: 'webhook_path')

          expect(setting).to be_valid
        end

        it 'ignores nil values' do
          existing_flow.flow_settings.find_by(flow_setting_id: 'webhook_path').update!(object: nil)
          setting = create_flow_setting(flow: other_flow, value: nil)

          expect(setting).to be_valid
        end
      end

      context 'when the flow type setting has no uniqueness scope' do
        before do
          create(:flow_type_setting, flow_type: flow_type, identifier: 'webhook_path', unique: :none)
        end

        let(:existing_flow) { create(:flow, project: project, flow_type: flow_type) }
        let(:other_flow) { create(:flow, project: project, flow_type: flow_type) }

        it 'allows the same value on another flow of the same project' do
          create_flow_setting(flow: existing_flow, value: { path: '/hook' }).save!
          setting = create_flow_setting(flow: other_flow, value: { path: '/hook' })

          expect(setting).to be_valid
        end
      end
    end
  end
end
