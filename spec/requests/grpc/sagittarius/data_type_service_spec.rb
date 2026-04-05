# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sagittarius.DataTypeService', :need_grpc_server do
  include GrpcHelpers

  let(:stub) { create_stub Tucana::Sagittarius::DataTypeService }

  describe 'Update' do
    let(:data_types) do
      [
        {
          identifier: 'positive_number',
          type: 'number',
          name: [
            { code: 'de_DE', content: 'Positive Zahl' }
          ],
          alias: [
            { code: 'de_DE', content: 'Positive Nummer' }
          ],
          display_message: [
            { code: 'de_DE', content: 'Zahl: ${0}' }
          ],
          rules: [
            Tucana::Shared::DefinitionDataTypeRule.create(:number_range, { from: 1, to: 100 })
          ],
          linked_data_type_identifiers: [],
          version: '0.0.0',
          definition_source: 'taurus',
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
      expect(data_type.runtime).to eq(runtime)
      expect(data_type.type).to eq('number')
      expect(data_type.identifier).to eq('positive_number')
      expect(data_type.definition_source).to eq('taurus')
      expect(data_type.names.count).to eq(1)
      expect(data_type.names.first.code).to eq('de_DE')
      expect(data_type.names.first.content).to eq('Positive Zahl')
      expect(data_type.aliases.count).to eq(1)
      expect(data_type.aliases.first.code).to eq('de_DE')
      expect(data_type.aliases.first.content).to eq('Positive Nummer')
      expect(data_type.display_messages.count).to eq(1)
      expect(data_type.display_messages.first.code).to eq('de_DE')
      expect(data_type.display_messages.first.content).to eq('Zahl: ${0}')
      expect(data_type.rules.count).to eq(1)
      expect(data_type.rules.first.variant).to eq('number_range')
      expect(data_type.rules.first.config).to eq({ 'from' => 1, 'to' => 100, 'steps' => 0 })
    end

    context 'with more rules' do
      let(:data_types) do
        [
          {
            identifier: 'positive_number',
            type: 'number',
            name: [
              { code: 'de_DE', content: 'Positive Zahl' }
            ],
            rules: [
              Tucana::Shared::DefinitionDataTypeRule.create(:number_range, { from: 1, to: 100, steps: 1 }),
              Tucana::Shared::DefinitionDataTypeRule.create(:regex, { pattern: '^\d+$' })
            ],
            linked_data_type_identifiers: [],
            version: '0.0.0',
          }
        ]
      end

      it 'creates a correct datatype with all rules' do
        expect(stub.update(message, authorization(runtime)).success).to be(true)

        expect(DataType.last.rules.count).to eq(2)
      end
    end

    context 'with linked data types' do
      let(:data_types) do
        [
          {
            identifier: 'HTTP_METHOD',
            type: 'string',
            linked_data_type_identifiers: [],
            version: '0.0.0',
          },
          {
            identifier: 'HTTP_URL',
            type: 'string',
            linked_data_type_identifiers: [],
            version: '0.0.0',
          },
          {
            identifier: 'OBJECT',
            type: 'T & {}',
            generic_keys: ['T'],
            linked_data_type_identifiers: [],
            version: '0.0.0',
          },
          {
            identifier: 'HTTP_REQUEST',
            type: '{ method: HTTP_METHOD, url: HTTP_URL, body: T, headers: OBJECT<{}> }',
            generic_keys: ['T'],
            linked_data_type_identifiers: %w[HTTP_METHOD HTTP_URL OBJECT],
            version: '0.0.0',
          }
        ]
      end

      it 'creates data types with links' do
        expect(stub.update(message, authorization(runtime)).success).to be(true)

        http_method = DataType.find_by(identifier: 'HTTP_METHOD')
        http_url = DataType.find_by(identifier: 'HTTP_URL')
        object = DataType.find_by(identifier: 'OBJECT')
        http_request = DataType.find_by(identifier: 'HTTP_REQUEST')

        expect(http_request).to be_present
        expect(http_request.referenced_data_types).to contain_exactly(http_method, http_url, object)
      end
    end

    context 'with dependent data types in wrong order' do
      let(:data_types) do
        [
          {
            identifier: 'HTTP_REQUEST',
            type: '{ method: HTTP_METHOD, url: HTTP_URL }',
            linked_data_type_identifiers: %w[HTTP_METHOD HTTP_URL],
            version: '0.0.0',
          },
          {
            identifier: 'HTTP_URL',
            type: 'string',
            linked_data_type_identifiers: [],
            version: '0.0.0',
          },
          {
            identifier: 'HTTP_METHOD',
            type: 'string',
            linked_data_type_identifiers: [],
            version: '0.0.0',
          }
        ]
      end

      it 'sorts and creates data types correctly' do
        expect(stub.update(message, authorization(runtime)).success).to be(true)

        http_request = DataType.find_by(identifier: 'HTTP_REQUEST')
        http_method = DataType.find_by(identifier: 'HTTP_METHOD')
        http_url = DataType.find_by(identifier: 'HTTP_URL')

        expect(http_request).to be_present
        expect(http_request.referenced_data_types).to contain_exactly(http_method, http_url)
      end
    end

    context 'when removing datatypes' do
      let!(:existing_data_type) { create(:data_type, runtime: runtime) }
      let(:data_types) { [] }

      it 'marks the datatype as removed' do
        stub.update(message, authorization(runtime))

        expect(existing_data_type.reload.removed_at).to be_present
      end
    end
  end
end
