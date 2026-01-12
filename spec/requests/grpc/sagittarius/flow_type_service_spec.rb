# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sagittarius.FlowTypeService', :need_grpc_server do
  include GrpcHelpers

  let(:stub) { create_stub Tucana::Sagittarius::FlowTypeService }
  let(:namespace) { create(:namespace) }
  let(:runtime) { create(:runtime, namespace: namespace) }

  describe 'Update' do
    let(:data_type) do
      create(:data_type, identifier: 'some_return_type_identifier', runtime: runtime)
    end

    let(:flow_types) do
      [
        {
          identifier: 'some_flow_type_identifier',
          settings: [
            {
              identifier: 'some_setting_identifier',
              unique: :PROJECT,
              data_type_identifier: create(:data_type, runtime: runtime).identifier,
              default_value: Tucana::Shared::Value.from_ruby({ 'value' => 'some default value' }),
              name: [
                { code: 'en_US', content: 'Some Setting' }
              ],
              description: [
                { code: 'en_US', content: 'This is a setting' }
              ],
            },
            {
              identifier: 'without_default',
              unique: :NONE,
              data_type_identifier: create(:data_type, runtime: runtime).identifier,
              default_value: nil,
              name: [
                { code: 'en_US', content: 'Some Setting' }
              ],
              description: [
                { code: 'en_US', content: 'This is a setting' }
              ],
            }
          ],
          name: [
            { code: 'de_DE', content: 'Keine Ahnung man' }
          ],
          description: [
            { code: 'en_US', content: "That's a description" }
          ],
          display_message: [
            { code: 'en_US', content: 'Flow Type: ${0}' }
          ],
          alias: [
            { code: 'de_DE', content: 'Irgendein Flow Typ' }
          ],
          editable: true,
          return_type_identifier: data_type.identifier,
          version: '0.0.0',
        }
      ]
    end

    let(:message) do
      Tucana::Sagittarius::FlowTypeUpdateRequest.new(flow_types: flow_types)
    end

    it 'creates a correct flowtype' do
      expect(stub.update(message, authorization(runtime)).success).to be(true)

      flow_type = FlowType.last
      expect(flow_type.identifier).to eq('some_flow_type_identifier')
      expect(flow_type.names.count).to eq(1)
      expect(flow_type.names.first.code).to eq('de_DE')
      expect(flow_type.names.first.content).to eq('Keine Ahnung man')

      expect(flow_type.descriptions.count).to eq(1)
      expect(flow_type.descriptions.first.code).to eq('en_US')
      expect(flow_type.descriptions.first.content).to eq("That's a description")

      expect(flow_type.display_messages.count).to eq(1)
      expect(flow_type.display_messages.first.code).to eq('en_US')
      expect(flow_type.display_messages.first.content).to eq('Flow Type: ${0}')

      expect(flow_type.aliases.count).to eq(1)
      expect(flow_type.aliases.first.code).to eq('de_DE')
      expect(flow_type.aliases.first.content).to eq('Irgendein Flow Typ')

      expect(flow_type.editable).to be true
      expect(flow_type.return_type.identifier).to eq('some_return_type_identifier')
      expect(flow_type.version).to eq('0.0.0')

      expect(flow_type.flow_type_settings.count).to eq(2)
      setting = flow_type.flow_type_settings.first
      expect(setting.identifier).to eq('some_setting_identifier')
      expect(setting.unique).to eq('project')
      expect(setting.default_value).to eq('value' => 'some default value')
      expect(setting.names.count).to eq(1)
      expect(setting.names.first.code).to eq('en_US')
      expect(setting.names.first.content).to eq('Some Setting')
      expect(setting.descriptions.count).to eq(1)
      expect(setting.descriptions.first.code).to eq('en_US')
      expect(setting.descriptions.first.content).to eq('This is a setting')
    end

    context 'when removing datatypes' do
      let!(:existing_flow_type) { create(:flow_type, runtime: runtime) }
      let(:flow_types) { [] }

      it 'marks the flowtype as removed' do
        stub.update(message, authorization(runtime))

        expect(existing_flow_type.reload.removed_at).to be_present
      end
    end
  end
end
