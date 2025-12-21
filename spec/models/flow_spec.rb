# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Flow do
  subject { create(:flow) }

  describe 'associations' do
    it { is_expected.to belong_to(:project).class_name('NamespaceProject') }
    it { is_expected.to belong_to(:flow_type) }
    it { is_expected.to belong_to(:starting_node).class_name('NodeFunction').optional }
    it { is_expected.to belong_to(:input_type).class_name('DataType').optional }
    it { is_expected.to belong_to(:return_type).class_name('DataType').optional }

    it { is_expected.to have_many(:flow_settings) }
    it { is_expected.to have_many(:node_functions) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:project_id) }
  end

  describe '#to_grpc' do
    let(:flow) do
      create(
        :flow,
        flow_type: create(:flow_type, identifier: 'HTTP'),
        flow_settings: [
          create(
            :flow_setting,
            flow_setting_id: 'HTTP_URL',
            object: { url: '/some-url' }
          )
        ]
      )
    end

    before do
      func = create(
        :node_function,
        flow: flow,
        node_parameters: [
          build(
            :node_parameter,
            runtime_parameter: build(
              :runtime_parameter_definition,
              data_type: build(
                :data_type_identifier,
                generic_key: 'T'
              )
            )
          )
        ]
      )

      flow.update!(starting_node: func)
    end

    it 'matches the model' do
      grpc_object = flow.to_grpc

      expect(grpc_object.to_h).to eq(
        {
          flow_id: flow.id,
          project_id: flow.project.id,
          project_slug: flow.project.slug,
          type: flow.flow_type.identifier,
          node_functions: [
            {
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
            }
          ],
          starting_node_id: flow.starting_node.id,
          settings: [
            database_id: flow.flow_settings.first.id,
            flow_setting_id: flow.flow_settings.first.flow_setting_id,
            object: {
              fields: {
                'url' => {
                  string_value: flow.flow_settings.first.object['url'],
                },
              },
            }
          ],
        }
      )
    end
  end
end
