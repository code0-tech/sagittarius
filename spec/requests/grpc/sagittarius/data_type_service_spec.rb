# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sagittarius.DataTypeService', :need_grpc_server do
  include GrpcHelpers

  let(:stub) { create_stub Tucana::Sagittarius::DataTypeService }

  describe 'Update' do
    let(:message) do
      Tucana::Sagittarius::DataTypeUpdateRequest.new(
        data_types: [
          {
            variant: :PRIMITIVE,
            identifier: 'positive_number',
            name: [
              { code: 'de_DE', content: 'Positive Zahl' }
            ],
            rules: [
              {
                variant: :NUMBER_RANGE,
                config: Google::Protobuf::Struct.from_hash(
                  {
                    'min' => 1,
                  }
                ),
              }
            ],
          }
        ]
      )
    end

    let(:namespace) { create(:namespace) }
    let(:runtime) { create(:runtime, namespace: namespace) }

    it 'is successful' do
      expect(stub.update(message, authorization(runtime)).success).to be(true)
    end

    it 'creates a correct datatype' do
      stub.update(message, authorization(runtime))

      data_type = DataType.last
      expect(data_type.namespace).to eq(namespace)
      expect(data_type.variant).to eq('primitive')
      expect(data_type.identifier).to eq('positive_number')
      expect(data_type.translations.count).to eq(1)
      expect(data_type.translations.first.code).to eq('de_DE')
      expect(data_type.translations.first.content).to eq('Positive Zahl')
      expect(data_type.rules.count).to eq(1)
      expect(data_type.rules.first.variant).to eq('number_range')
      expect(data_type.rules.first.config).to eq({ 'min' => 1 })
    end

    pending 'updates a datatype correctly'
    pending 'does not delete datatypes'
  end
end
