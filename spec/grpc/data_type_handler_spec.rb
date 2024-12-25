# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataTypeHandler do
  subject(:handler) { described_class.new }

  describe '.update' do
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

    it 'returns message with same id' do
      Sagittarius::Context.with_context(runtime: { id: create(:runtime).id }) do
        p handler.update(message, nil)
        p DataType.all
        p DataTypeRule.all
        p Translation.all
      end
    end
  end
end
