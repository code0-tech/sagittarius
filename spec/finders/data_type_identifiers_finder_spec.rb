# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataTypeIdentifiersFinder do
  # rubocop:disable RSpec/IndexedLet -- this is a finder and we need to setup multiple objects of the same time
  # rubocop:disable RSpec/LetSetup -- a finder spec needs more objects than referenced in the spec to test that they are excluded in the result
  describe '#execute' do
    let(:runtime) { create(:runtime) }
    let(:other_runtime) { create(:runtime) }

    let!(:data_type1) { create(:data_type, runtime: runtime) }
    let!(:data_type2) { create(:data_type, runtime: runtime) }
    let!(:data_type3) { create(:data_type, runtime: other_runtime) }

    let!(:data_type_identifier1) do
      create(:data_type_identifier, runtime: runtime, data_type: data_type1)
    end
    let!(:data_type_identifier2) do
      create(:data_type_identifier, runtime: runtime, data_type: data_type2)
    end
    let!(:data_type_identifier3) do
      create(:data_type_identifier, runtime: other_runtime, data_type: data_type3)
    end

    context 'without any parameters' do
      it 'returns all data type identifiers' do
        finder = described_class.new({})
        result = finder.execute

        expect(result).to contain_exactly(data_type_identifier1, data_type_identifier2, data_type_identifier3)
      end
    end

    context 'with runtime parameter' do
      it 'filters data type identifiers by runtime' do
        finder = described_class.new({ runtime: runtime })
        result = finder.execute

        expect(result).to contain_exactly(data_type_identifier1, data_type_identifier2)
        expect(result).not_to include(data_type_identifier3)
      end

      it 'returns empty result when runtime has no data type identifiers' do
        empty_runtime = create(:runtime)
        finder = described_class.new({ runtime: empty_runtime })
        result = finder.execute

        expect(result).to be_empty
      end
    end

    context 'with function_definition parameter' do
      let(:return_data_type) { create(:data_type) }
      let(:param_data_type1) { create(:data_type) }
      let(:param_data_type2) { create(:data_type) }
      let(:unrelated_data_type) { create(:data_type) }

      let(:return_type) do
        create(:data_type_identifier, data_type: return_data_type)
      end
      let(:param_type1) do
        create(:data_type_identifier, data_type: param_data_type1)
      end
      let(:param_type2) do
        create(:data_type_identifier, data_type: param_data_type2)
      end
      let(:unrelated_type) do
        create(:data_type_identifier, data_type: unrelated_data_type)
      end

      let(:function_definition) do
        create(:function_definition, return_type_id: return_type.id)
      end

      let!(:parameter_def1) do
        create(:parameter_definition,
               function_definition: function_definition,
               runtime_parameter_definition: create(
                 :runtime_parameter_definition,
                 runtime_function_definition: function_definition.runtime_function_definition,
                 data_type: param_type1
               ),
               data_type: param_type1)
      end

      let!(:parameter_def2) do
        create(:parameter_definition,
               function_definition: function_definition,
               runtime_parameter_definition: create(
                 :runtime_parameter_definition,
                 runtime_function_definition: function_definition.runtime_function_definition,
                 data_type: param_type2
               ),
               data_type: param_type2)
      end

      it 'returns data type identifiers related to function definition' do
        finder = described_class.new({ function_definition: function_definition })
        result = finder.execute

        expect(result).to contain_exactly(return_type, param_type1, param_type2)
        expect(result).not_to include(unrelated_type)
      end

      it 'includes return type when function has return type' do
        finder = described_class.new({ function_definition: function_definition })
        result = finder.execute

        expect(result).to include(return_type)
      end

      it 'includes parameter types when function has parameters' do
        finder = described_class.new({ function_definition: function_definition })
        result = finder.execute

        expect(result).to include(param_type1, param_type2)
      end

      it 'returns empty result when function definition has no types' do
        empty_function = create(:function_definition, return_type_id: nil)
        finder = described_class.new({ function_definition: empty_function })
        result = finder.execute

        expect(result).to be_empty
      end
    end

    context 'with expand_recursively parameter' do
      let!(:data_type_identifier_in_contains_type_rule) do
        create(:data_type_identifier, data_type: data_type3, runtime: runtime).tap do |dti|
          create(
            :data_type_rule,
            data_type: data_type1,
            variant: :contains_type,
            config: {
              data_type_identifier: {
                data_type_identifier: data_type3.identifier,
              },
              data_type_identifier_id: dti.id,
            }
          )
        end
      end

      let!(:data_type_identifier_in_input_types_rule) do
        create(:data_type_identifier, data_type: data_type3, runtime: runtime).tap do |dti|
          create(
            :data_type_rule,
            data_type: data_type1,
            variant: :input_types,
            config: {
              input_types: [
                {
                  data_type_identifier: {
                    data_type_identifier: data_type3.identifier,
                  },
                  data_type_identifier_id: dti.id,
                  input_identifier: 'something',
                }
              ],

            }
          )
        end
      end

      let!(:data_type_identifier_as_parent_type) do
        create(:data_type_identifier, data_type: data_type3, runtime: runtime).tap do |dti|
          data_type1.parent_type = dti
          data_type1.save!
        end
      end

      let!(:data_type_identifier_in_generic_mapper_source) do
        create(:data_type_identifier, data_type: data_type1, runtime: runtime)
      end

      let!(:second_data_type_identifier_in_generic_mapper_source) do
        create(:data_type_identifier, data_type: data_type2, runtime: runtime)
      end

      let!(:data_type_identifier_with_generic_mapper) do
        gm = create(:generic_mapper, target: 'A', sources: [data_type_identifier_in_generic_mapper_source])
        gt = create(:generic_type, generic_mappers: [gm])
        create(:data_type_identifier, generic_type: gt, runtime: runtime)
      end

      let!(:second_data_type_identifier_with_generic_mapper) do
        gm = create(:generic_mapper, target: 'B', sources: [second_data_type_identifier_in_generic_mapper_source])
        gt = create(:generic_type, generic_mappers: [gm])
        create(:data_type_identifier, generic_type: gt, runtime: runtime)
      end

      let!(:data_type_identifier_with_nested_generic_mapper) do
        gm = create(:generic_mapper, target: 'A', sources: [data_type_identifier_with_generic_mapper])
        gt = create(:generic_type, generic_mappers: [gm])
        create(:data_type_identifier, generic_type: gt, runtime: runtime)
      end

      it 'recursively expands data type identifiers through multiple levels' do
        finder = described_class.new({ expand_recursively: true })
        allow(finder).to receive(:base_scope).and_return(
          DataTypeIdentifier.where(id: data_type_identifier_with_nested_generic_mapper.id)
        )

        result = finder.execute

        expect(result.map(&:id)).to contain_exactly(
          data_type_identifier_with_nested_generic_mapper.id,
          data_type_identifier_with_generic_mapper.id,
          data_type_identifier_in_generic_mapper_source.id,
          data_type_identifier_in_contains_type_rule.id,
          data_type_identifier_in_input_types_rule.id,
          data_type_identifier_as_parent_type.id
        )
      end

      it 'does not expand when expand_recursively is false' do
        finder = described_class.new({ expand_recursively: false })
        allow(finder).to receive(:base_scope).and_return(
          DataTypeIdentifier.where(id: data_type_identifier_with_nested_generic_mapper.id)
        )

        result = finder.execute

        expect(result.map(&:id)).to contain_exactly(data_type_identifier_with_nested_generic_mapper.id)
      end

      it 'does not expand when expand_recursively is not provided' do
        finder = described_class.new({})
        allow(finder).to receive(:base_scope).and_return(
          DataTypeIdentifier.where(id: data_type_identifier_with_nested_generic_mapper.id)
        )

        result = finder.execute

        expect(result.map(&:id)).to contain_exactly(data_type_identifier_with_nested_generic_mapper.id)
      end

      it 'handles identifiers with no children' do
        leaf_data_type = create(:data_type)
        leaf_identifier = create(:data_type_identifier, data_type: leaf_data_type)

        finder = described_class.new({ expand_recursively: true })
        allow(finder).to receive(:base_scope).and_return(
          DataTypeIdentifier.where(id: leaf_identifier.id)
        )

        result = finder.execute

        expect(result.map(&:id)).to contain_exactly(leaf_identifier.id)
      end

      it 'orders results by id' do
        finder = described_class.new({ expand_recursively: true })
        allow(finder).to receive(:base_scope).and_return(
          DataTypeIdentifier.where(id: data_type_identifier_with_nested_generic_mapper.id)
        )

        result = finder.execute

        expect(result.map(&:id)).to eq(result.map(&:id).sort)
      end

      it 'handles multiple starting identifiers' do
        finder = described_class.new({ expand_recursively: true })
        allow(finder).to receive(:base_scope).and_return(
          DataTypeIdentifier.where(id: [
                                     data_type_identifier_with_nested_generic_mapper.id,
                                     second_data_type_identifier_with_generic_mapper.id
                                   ])
        )

        result = finder.execute

        expect(result.map(&:id)).to contain_exactly(
          data_type_identifier_with_nested_generic_mapper.id,
          second_data_type_identifier_with_generic_mapper.id,
          data_type_identifier_with_generic_mapper.id,
          second_data_type_identifier_in_generic_mapper_source.id,
          data_type_identifier_in_generic_mapper_source.id,
          data_type_identifier_in_contains_type_rule.id,
          data_type_identifier_in_input_types_rule.id,
          data_type_identifier_as_parent_type.id
        )
      end
    end
  end
  # rubocop:enable RSpec/LetSetup
  # rubocop:enable RSpec/IndexedLet
end
