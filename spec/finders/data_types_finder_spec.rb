# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataTypesFinder do
  # rubocop:disable RSpec/IndexedLet -- a finder needs to set up a lot of data with the same type
  describe '#execute' do
    let(:runtime) { create(:runtime) }
    let!(:data_type1) { create(:data_type, runtime: runtime) }
    let!(:data_type2) { create(:data_type, runtime: runtime) }
    let!(:data_type3) { create(:data_type, runtime: runtime) }
    let!(:unrelated_data_type) { create(:data_type, runtime: runtime) }

    context 'without any parameters' do
      it 'returns all data types' do
        finder = described_class.new({})
        result = finder.execute

        expect(result).to include(data_type1, data_type2, data_type3, unrelated_data_type)
      end
    end

    context 'with data_type parameter' do
      before do
        create(:data_type_data_type_link, data_type: data_type1, referenced_data_type: data_type2)
        create(:data_type_data_type_link, data_type: data_type1, referenced_data_type: data_type3)
      end

      it 'returns referenced data types' do
        finder = described_class.new({ data_type: data_type1 })
        result = finder.execute

        expect(result).to contain_exactly(data_type2, data_type3)
      end
    end

    context 'with runtime_function_definition parameter' do
      let(:runtime_function_definition) { create(:runtime_function_definition, runtime: runtime) }

      before do
        create(:runtime_function_definition_data_type_link,
               runtime_function_definition: runtime_function_definition,
               referenced_data_type: data_type1)
        create(:runtime_function_definition_data_type_link,
               runtime_function_definition: runtime_function_definition,
               referenced_data_type: data_type2)
      end

      it 'returns referenced data types' do
        finder = described_class.new({ runtime_function_definition: runtime_function_definition })
        result = finder.execute

        expect(result).to contain_exactly(data_type1, data_type2)
      end
    end

    context 'with flow_type parameter' do
      let(:flow_type) { create(:flow_type, runtime: runtime) }

      before do
        create(:flow_type_data_type_link, flow_type: flow_type, referenced_data_type: data_type1)
        create(:flow_type_data_type_link, flow_type: flow_type, referenced_data_type: data_type2)
      end

      it 'returns referenced data types' do
        finder = described_class.new({ flow_type: flow_type })
        result = finder.execute

        expect(result).to contain_exactly(data_type1, data_type2)
      end
    end

    context 'with flow parameter' do
      let(:project) { create(:namespace_project) }
      let(:flow) { create(:flow, project: project) }

      before do
        create(:flow_data_type_link, flow: flow, referenced_data_type: data_type1)
        create(:flow_data_type_link, flow: flow, referenced_data_type: data_type3)
      end

      it 'returns referenced data types' do
        finder = described_class.new({ flow: flow })
        result = finder.execute

        expect(result).to contain_exactly(data_type1, data_type3)
      end
    end

    context 'with expand_recursively parameter' do
      let!(:data_type4) { create(:data_type, runtime: runtime) }
      let!(:data_type5) { create(:data_type, runtime: runtime) }

      before do
        create(:data_type_data_type_link, data_type: data_type1, referenced_data_type: data_type2)
        create(:data_type_data_type_link, data_type: data_type2, referenced_data_type: data_type3)
        create(:data_type_data_type_link, data_type: data_type3, referenced_data_type: data_type4)
      end

      it 'recursively expands data types through multiple levels' do
        finder = described_class.new({ data_type: data_type1, expand_recursively: true })
        result = finder.execute

        expect(result).to contain_exactly(data_type2, data_type3, data_type4)
      end

      it 'does not expand when expand_recursively is false' do
        finder = described_class.new({ data_type: data_type1, expand_recursively: false })
        result = finder.execute

        expect(result).to contain_exactly(data_type2)
      end

      it 'does not expand when expand_recursively is not provided' do
        finder = described_class.new({ data_type: data_type1 })
        result = finder.execute

        expect(result).to contain_exactly(data_type2)
      end

      it 'handles data types with no children' do
        finder = described_class.new({ data_type: data_type5, expand_recursively: true })
        result = finder.execute

        expect(result).to be_empty
      end

      it 'orders results by id' do
        finder = described_class.new({ data_type: data_type1, expand_recursively: true })
        result = finder.execute

        expect(result.map(&:id)).to eq(result.map(&:id).sort)
      end
    end
  end
  # rubocop:enable RSpec/IndexedLet
end
