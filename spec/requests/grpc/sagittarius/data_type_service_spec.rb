# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sagittarius.DataTypeService', :need_grpc_server do
  include GrpcHelpers

  let(:stub) { create_stub Tucana::Sagittarius::DataTypeService }

  describe 'Update' do
    let(:data_types) do
      [
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
    end

    let(:message) do
      Tucana::Sagittarius::DataTypeUpdateRequest.new(data_types: data_types)
    end

    let(:namespace) { create(:namespace) }
    let(:runtime) { create(:runtime, namespace: namespace) }

    it 'creates a correct datatype' do
      expect(stub.update(message, authorization(runtime)).success).to be(true)

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

    context 'with dependent data types' do
      let(:data_types) do
        [
          {
            variant: :PRIMITIVE,
            identifier: 'small_positive_number',
            name: [
              { code: 'de_DE', content: 'Kleine positive Zahl' }
            ],
            parent_type_identifier: 'positive_number',
            rules: [
              {
                variant: :NUMBER_RANGE,
                config: Google::Protobuf::Struct.from_hash(
                  {
                    'max' => 9,
                  }
                ),
              }
            ],
          },
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
      end

      it 'creates data types' do
        expect(stub.update(message, authorization(runtime)).success).to be(true)

        positive_number = DataType.find_by(identifier: 'positive_number')
        small_positive_number = DataType.find_by(identifier: 'small_positive_number')

        expect(positive_number).to be_present
        expect(small_positive_number).to be_present

        expect(small_positive_number.parent_type).to eq(positive_number)
      end
    end
  end
end
