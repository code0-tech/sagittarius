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
          name: [
            { code: 'de_DE', content: 'Keine Ahnung man' }
          ],
          description: [
            { code: 'en_US', content: "That's a description" }
          ],
          editable: true,
          return_type_identifier: data_type.identifier,
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

      expect(flow_type.editable).to be true
      expect(flow_type.return_type.identifier).to eq('some_return_type_identifier')
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
