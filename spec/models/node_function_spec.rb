# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NodeFunction do
  subject { create(:node_function) }

  describe 'associations' do
    it { is_expected.to belong_to(:function_definition).class_name('FunctionDefinition') }
    it { is_expected.to belong_to(:next_node).class_name('NodeFunction').optional }
    it { is_expected.to belong_to(:flow).class_name('Flow') }

    it { is_expected.to have_many(:node_parameter_values).inverse_of(:function_value) }
    it { is_expected.to have_many(:node_parameters).inverse_of(:node_function) }
  end

  describe '#ordered_parameters' do
    let(:runtime) { create(:runtime) }

    let(:data_type_identifier) do
      create(
        :data_type_identifier,
        data_type: create(:data_type, runtime: runtime)
      )
    end

    let(:runtime_function_definition) do
      create(
        :runtime_function_definition,
        runtime: runtime
      ).tap do |rfd|
        rfd.parameters << create(
          :runtime_parameter_definition,
          runtime_function_definition: rfd,
          runtime_name: 'param1',
          data_type: data_type_identifier
        )

        rfd.parameters << create(
          :runtime_parameter_definition,
          runtime_function_definition: rfd,
          runtime_name: 'param2',
          data_type: data_type_identifier
        )

        rfd.parameters << create(
          :runtime_parameter_definition,
          runtime_function_definition: rfd,
          runtime_name: 'param3',
          data_type: data_type_identifier
        )
      end
    end

    let(:function_definition) do
      create(
        :function_definition,
        runtime_function_definition: runtime_function_definition
      )
    end

    let(:node_function) do
      create(
        :node_function,
        function_definition: function_definition
      ).tap do |node|
        node.node_parameters << create(
          :node_parameter,
          node_function: node,
          parameter_definition: create(
            :parameter_definition,
            data_type: data_type_identifier,
            runtime_parameter_definition: runtime_function_definition.parameters[1]
          )
        )
        node.node_parameters << create(
          :node_parameter,
          node_function: node,
          parameter_definition: create(
            :parameter_definition,
            data_type: data_type_identifier,
            runtime_parameter_definition: runtime_function_definition.parameters[2]
          )
        )
        node.node_parameters << create(
          :node_parameter,
          node_function: node,
          parameter_definition: create(
            :parameter_definition,
            data_type: data_type_identifier,
            runtime_parameter_definition: runtime_function_definition.parameters[0]
          )
        )
      end
    end

    it 'orders node parameters as in runtime function definition' do
      expect(node_function.ordered_parameters.to_a).to eq(
        [
          node_function.node_parameters[2],
          node_function.node_parameters[0],
          node_function.node_parameters[1]
        ]
      )
    end
  end
end
