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
          alias: [
            { code: 'de_DE', content: 'Positive Nummer' }
          ],
          display_message: [
            { code: 'de_DE', content: 'Zahl: ${0}' }
          ],
          rules: [
            Tucana::Shared::DefinitionDataTypeRule.create(
              :contains_type,
              { data_type_identifier: { generic_key: 'T' } }
            )
          ],
          version: '0.0.0',
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
      expect(data_type.variant).to eq('primitive')
      expect(data_type.identifier).to eq('positive_number')
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
      expect(data_type.rules.first.variant).to eq('contains_type')
      expect(data_type.rules.first.config).to eq(
        {
          'data_type_identifier' => { 'generic_key' => 'T' },
          'data_type_identifier_id' => DataTypeIdentifier.find_by(runtime: runtime, generic_key: 'T').id,
        }
      )
    end

    context 'with more rules' do
      let(:data_types) do
        [
          {
            variant: :PRIMITIVE,
            identifier: 'parent_type_identifier',
            version: '0.0.0',
          },
          {
            variant: :PRIMITIVE,
            identifier: 'some_type',
            version: '0.0.0',
          },
          {
            variant: :PRIMITIVE,
            identifier: 'positive_number',
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
              Tucana::Shared::DefinitionDataTypeRule.create(:contains_key, {
                                                              key: 'example_key',
                                                              data_type_identifier: {
                                                                data_type_identifier: 'some_type',
                                                              },
                                                            }),
              Tucana::Shared::DefinitionDataTypeRule.create(:contains_type, {
                                                              data_type_identifier: { generic_key: 'T' },
                                                            }),
              Tucana::Shared::DefinitionDataTypeRule.create(:item_of_collection, { items: [] }),
              Tucana::Shared::DefinitionDataTypeRule.create(:number_range, { from: 1, to: 100, steps: 1 }),
              Tucana::Shared::DefinitionDataTypeRule.create(:regex, { pattern: '^\d+$' }),
              Tucana::Shared::DefinitionDataTypeRule.create(:input_types, {
                                                              input_types: [{
                                                                data_type_identifier: {
                                                                  data_type_identifier: 'some_type',
                                                                },
                                                                input_identifier: 'input_1',
                                                              }],
                                                            }),
              Tucana::Shared::DefinitionDataTypeRule.create(:return_type, {
                                                              data_type_identifier: {
                                                                data_type_identifier: 'some_type',
                                                              },
                                                            }),
              Tucana::Shared::DefinitionDataTypeRule.create(:parent_type, {
                                                              parent_type: {
                                                                data_type_identifier: 'parent_type_identifier',
                                                              },
                                                            })
            ],
            version: '0.0.0',
          }
        ]
      end

      it 'creates a correct datatype with all rules' do
        expect(stub.update(message, authorization(runtime)).success).to be(true)

        expect(DataType.last.rules.count).to eq(8)
      end
    end

    context 'with dependent data types' do
      context 'with parent_type rule' do
        let(:data_types) do
          [
            {
              variant: :PRIMITIVE,
              identifier: 'small_positive_number',
              name: [
                { code: 'de_DE', content: 'Kleine positive Zahl' }
              ],
              rules: [
                Tucana::Shared::DefinitionDataTypeRule.create(:number_range, { from: 9 }),
                Tucana::Shared::DefinitionDataTypeRule.create(
                  :parent_type,
                  { parent_type: {
                    generic_type: {
                      data_type_identifier: 'positive_number',
                      generic_mappers: [
                        {
                          source: [
                            {
                              data_type_identifier: 'some_other_dependency',
                            }
                          ],
                          target: 'T',
                          generic_combinations: [],
                        }
                      ],
                    },
                  } }
                )
              ],
              generic_keys: ['T'],
              version: '0.0.0',
            },

            {
              variant: :PRIMITIVE,
              identifier: 'some_other_dependency',
              name: [
                { code: 'de_DE', content: 'Positive Zahl' }
              ],
              rules: [
                Tucana::Shared::DefinitionDataTypeRule.create(:number_range, { from: 1 })
              ],
              version: '0.0.0',
            },
            {
              variant: :PRIMITIVE,
              identifier: 'positive_number',
              name: [
                { code: 'de_DE', content: 'Positive Zahl' }
              ],
              rules: [
                Tucana::Shared::DefinitionDataTypeRule.create(:number_range, { from: 1 })
              ],
              version: '0.0.0',
            }
          ]
        end

        it 'creates data types' do
          expect(stub.update(message, authorization(runtime)).success).to be(true)

          positive_number = DataType.find_by(identifier: 'positive_number')
          small_positive_number = DataType.find_by(identifier: 'small_positive_number')

          expect(positive_number).to be_present
          expect(small_positive_number).to be_present
          expect(positive_number.generic_keys).to be_empty
          expect(small_positive_number.generic_keys).to eq(['T'])
          expect(small_positive_number.parent_type.generic_type.data_type).to eq(positive_number)
        end
      end

      context 'with contains_key rule' do
        let(:data_types) do
          [
            {
              variant: :PRIMITIVE,
              identifier: 'type1',
              rules: [
                Tucana::Shared::DefinitionDataTypeRule.create(
                  :contains_key,
                  {
                    key: 'test',
                    data_type_identifier: {
                      generic_type: {
                        data_type_identifier: 'type2',
                        generic_mappers: [
                          {
                            source: [
                              {
                                data_type_identifier: 'type3',
                              }
                            ],
                            target: 'T',
                            generic_combinations: [],
                          }
                        ],
                      },
                    },
                  }
                )
              ],
              generic_keys: ['T'],
              version: '0.0.0',
            },

            {
              variant: :PRIMITIVE,
              identifier: 'type2',
              version: '0.0.0',
            },
            {
              variant: :PRIMITIVE,
              identifier: 'type3',
              version: '0.0.0',
            }
          ]
        end

        it 'creates data types' do
          expect(stub.update(message, authorization(runtime)).success).to be(true)

          expect(DataType.find_by(identifier: 'type1')).to be_present
        end
      end

      context 'with contains_type rule' do
        let(:data_types) do
          [
            {
              variant: :PRIMITIVE,
              identifier: 'type1',
              rules: [
                Tucana::Shared::DefinitionDataTypeRule.create(
                  :contains_type,
                  {
                    data_type_identifier: {
                      generic_type: {
                        data_type_identifier: 'type2',
                        generic_mappers: [
                          {
                            source: [
                              {
                                data_type_identifier: 'type3',
                              }
                            ],
                            target: 'T',
                            generic_combinations: [],
                          }
                        ],
                      },
                    },
                  }
                )
              ],
              generic_keys: ['T'],
              version: '0.0.0',
            },

            {
              variant: :PRIMITIVE,
              identifier: 'type2',
              version: '0.0.0',
            },
            {
              variant: :PRIMITIVE,
              identifier: 'type3',
              version: '0.0.0',
            }
          ]
        end

        it 'creates data types' do
          expect(stub.update(message, authorization(runtime)).success).to be(true)

          expect(DataType.find_by(identifier: 'type1')).to be_present
        end
      end

      context 'with input_types rule' do
        let(:data_types) do
          [
            {
              variant: :PRIMITIVE,
              identifier: 'type1',
              rules: [
                Tucana::Shared::DefinitionDataTypeRule.create(
                  :input_types,
                  {
                    input_types: [
                      {
                        data_type_identifier: {
                          generic_type: {
                            data_type_identifier: 'type2',
                            generic_mappers: [
                              {
                                source: [
                                  {
                                    data_type_identifier: 'type3',
                                  }
                                ],
                                target: 'T',
                                generic_combinations: [],
                              }
                            ],
                          },
                        },
                        input_identifier: 'input',
                      }
                    ],
                  }
                )
              ],
              generic_keys: ['T'],
              version: '0.0.0',
            },

            {
              variant: :PRIMITIVE,
              identifier: 'type2',
              version: '0.0.0',
            },
            {
              variant: :PRIMITIVE,
              identifier: 'type3',
              version: '0.0.0',
            }
          ]
        end

        it 'creates data types' do
          expect(stub.update(message, authorization(runtime)).success).to be(true)

          expect(DataType.find_by(identifier: 'type1')).to be_present
        end
      end

      context 'with return_type rule' do
        let(:data_types) do
          [
            {
              variant: :PRIMITIVE,
              identifier: 'type1',
              rules: [
                Tucana::Shared::DefinitionDataTypeRule.create(
                  :return_type,
                  {
                    data_type_identifier: {
                      generic_type: {
                        data_type_identifier: 'type2',
                        generic_mappers: [
                          {
                            source: [
                              {
                                data_type_identifier: 'type3',
                              }
                            ],
                            target: 'T',
                            generic_combinations: [],
                          }
                        ],
                      },
                    },
                  }
                )
              ],
              generic_keys: ['T'],
              version: '0.0.0',
            },

            {
              variant: :PRIMITIVE,
              identifier: 'type2',
              version: '0.0.0',
            },
            {
              variant: :PRIMITIVE,
              identifier: 'type3',
              version: '0.0.0',
            }
          ]
        end

        it 'creates data types' do
          expect(stub.update(message, authorization(runtime)).success).to be(true)

          expect(DataType.find_by(identifier: 'type1')).to be_present
        end
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
