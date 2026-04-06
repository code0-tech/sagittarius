# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sagittarius.FlowTypeService', :need_grpc_server do
  include GrpcHelpers

  let(:stub) { create_stub Tucana::Sagittarius::FlowTypeService }
  let(:namespace) { create(:namespace) }
  let(:runtime) { create(:runtime, namespace: namespace) }

  describe 'Update' do
    let!(:http_response_data_type) { create(:data_type, identifier: 'HTTP_RESPONSE', runtime: runtime) }
    let!(:rest_adapter_input_data_type) { create(:data_type, identifier: 'REST_ADAPTER_INPUT', runtime: runtime) }

    let(:flow_types) do
      [
        {
          identifier: 'REST',
          settings: [
            {
              identifier: 'HTTP_URL',
              unique: :PROJECT,
              name: [
                { code: 'en_US', content: 'URL' }
              ],
              description: [
                { code: 'en_US', content: 'Specifies the HTTP URL endpoint.' }
              ],
            },
            {
              identifier: 'HTTP_METHOD',
              unique: :NONE,
              default_value: Tucana::Shared::Value.from_ruby('GET'),
              name: [
                { code: 'en_US', content: 'Method' }
              ],
              description: [
                { code: 'en_US', content: 'Specifies the HTTP request method.' }
              ],
            }
          ],
          signature: '(input: REST_ADAPTER_INPUT): HTTP_RESPONSE',
          linked_data_type_identifiers: %w[REST_ADAPTER_INPUT HTTP_RESPONSE],
          name: [
            { code: 'en_US', content: 'Rest Endpoint' }
          ],
          description: [
            { code: 'en_US', content: 'A REST API endpoint' }
          ],
          display_message: [
            { code: 'en_US', content: 'Trigger Rest-Flow on ${method} with a Request to ${route}' }
          ],
          alias: [
            { code: 'en_US', content: 'http;rest;route' }
          ],
          editable: false,
          version: '0.0.0',
          definition_source: 'draco-rest',
          display_icon: 'rest-icon',
        }
      ]
    end

    let(:message) do
      Tucana::Sagittarius::FlowTypeUpdateRequest.new(flow_types: flow_types)
    end

    it 'creates a correct flowtype' do
      expect(stub.update(message, authorization(runtime)).success).to be(true)

      flow_type = FlowType.last
      expect(flow_type.identifier).to eq('REST')
      expect(flow_type.signature).to eq('(input: REST_ADAPTER_INPUT): HTTP_RESPONSE')
      expect(flow_type.editable).to be false
      expect(flow_type.version).to eq('0.0.0')
      expect(flow_type.definition_source).to eq('draco-rest')
      expect(flow_type.display_icon).to eq('rest-icon')
      expect(flow_type.referenced_data_types).to contain_exactly(rest_adapter_input_data_type,
                                                                 http_response_data_type)

      expect(flow_type.names.count).to eq(1)
      expect(flow_type.names.first.code).to eq('en_US')
      expect(flow_type.names.first.content).to eq('Rest Endpoint')

      expect(flow_type.descriptions.count).to eq(1)
      expect(flow_type.descriptions.first.content).to eq('A REST API endpoint')

      expect(flow_type.display_messages.count).to eq(1)
      expect(flow_type.display_messages.first.content).to eq(
        'Trigger Rest-Flow on ${method} with a Request to ${route}'
      )

      expect(flow_type.aliases.count).to eq(1)
      expect(flow_type.aliases.first.content).to eq('http;rest;route')

      expect(flow_type.flow_type_settings.count).to eq(2)

      url_setting = flow_type.flow_type_settings.find_by(identifier: 'HTTP_URL')
      expect(url_setting.unique).to eq('project')
      expect(url_setting.default_value).to be_nil
      expect(url_setting.names.first.content).to eq('URL')
      expect(url_setting.descriptions.first.content).to eq('Specifies the HTTP URL endpoint.')

      method_setting = flow_type.flow_type_settings.find_by(identifier: 'HTTP_METHOD')
      expect(method_setting.unique).to eq('none')
      expect(method_setting.default_value).to eq('GET')
      expect(method_setting.names.first.content).to eq('Method')
      expect(method_setting.descriptions.first.content).to eq('Specifies the HTTP request method.')
    end

    context 'when removing flowtypes' do
      let!(:existing_flow_type) { create(:flow_type, runtime: runtime) }
      let(:flow_types) { [] }

      it 'marks the flowtype as removed' do
        stub.update(message, authorization(runtime))

        expect(existing_flow_type.reload.removed_at).to be_present
      end
    end
  end
end
