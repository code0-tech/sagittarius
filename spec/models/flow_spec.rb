# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Flow do
  subject { create(:flow) }

  describe 'associations' do
    it { is_expected.to belong_to(:project).class_name('NamespaceProject') }
    it { is_expected.to belong_to(:flow_type) }
    it { is_expected.to belong_to(:starting_node).class_name('NodeFunction') }
    it { is_expected.to belong_to(:input_type).class_name('DataType').optional }
    it { is_expected.to belong_to(:return_type).class_name('DataType').optional }

    it { is_expected.to have_many(:flow_settings) }
  end

  describe '#to_grpc' do
    let(:flow) do
      create(:flow,
             flow_settings: [
               create(:flow_setting,
                      flow_setting_id: 'example_key',
                      object: { some_key: 'some_value' })
             ],
             starting_node: create(:node_function,
                                   node_parameters: [
                                     create(:node_parameter,
                                            runtime_parameter: create(:runtime_parameter_definition,
                                                                      data_type: create(:data_type_identifier,
                                                                                        generic_key: 'T')))
                                   ]))
    end

    it 'matches the model' do
      grpc_object = flow.to_grpc

      expect(grpc_object.to_h).to eq({
                                       flow_id: flow.id,
                                       project_id: flow.project.id,
                                       type: flow.flow_type.identifier,
                                       starting_node: {
                                         database_id: flow.starting_node.id,
                                         runtime_function_id: flow.starting_node.runtime_function.runtime_name,
                                         parameters: [
                                           {
                                             database_id: flow.starting_node.node_parameters.first.id,
                                             runtime_parameter_id:
                                               flow.starting_node.node_parameters.first.runtime_parameter.runtime_name,
                                             value: {
                                               literal_value: {
                                                 string_value: flow.starting_node.node_parameters.first.literal_value,
                                               },
                                             },
                                           }
                                         ],
                                       },
                                       settings: [
                                         database_id: flow.flow_settings.first.id,
                                         flow_setting_id: flow.flow_settings.first.flow_setting_id,
                                         object: {
                                           fields: {
                                             'some_key' => {
                                               string_value: flow.flow_settings.first.object['some_key'],
                                             },
                                           },
                                         }
                                       ],
                                     })
    end
  end
end
