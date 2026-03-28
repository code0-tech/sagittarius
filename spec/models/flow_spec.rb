# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Flow do
  subject { create(:flow) }

  describe 'associations' do
    it { is_expected.to belong_to(:project).class_name('NamespaceProject') }
    it { is_expected.to belong_to(:flow_type) }
    it { is_expected.to belong_to(:starting_node).class_name('NodeFunction').optional }

    it { is_expected.to have_many(:flow_settings) }
    it { is_expected.to have_many(:node_functions) }

    it { is_expected.to have_many(:flow_data_type_links).inverse_of(:flow) }

    it { is_expected.to have_many(:referenced_data_types).through(:flow_data_type_links).source(:referenced_data_type) }
  end

  describe 'validations' do
    it { is_expected.to allow_values(*described_class::VALIDATION_STATUS.keys).for(:validation_status) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive.scoped_to(:project_id) }

    it { is_expected.to validate_length_of(:input_type).is_at_most(2000) }
    it { is_expected.to validate_length_of(:return_type).is_at_most(2000) }
  end

  describe 'scopes' do
    describe 'validation status' do
      let!(:unvalidated_flow) { create(:flow, validation_status: :unvalidated) }
      let!(:valid_flow) { create(:flow, validation_status: :valid) }
      let!(:invalid_flow) { create(:flow, validation_status: :invalid) }

      it { expect(described_class.validation_status_unvalidated).to contain_exactly(unvalidated_flow) }
      it { expect(described_class.validation_status_valid).to contain_exactly(valid_flow) }
      it { expect(described_class.validation_status_invalid).to contain_exactly(invalid_flow) }
    end
  end

  describe '#to_grpc' do
    let(:flow) do
      create(
        :flow,
        flow_type: create(:flow_type, identifier: 'HTTP'),
        input_type: 'string',
        return_type: 'number',
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
      runtime = create(:runtime, namespace: flow.project.namespace)
      rfd = create(:runtime_function_definition, runtime: runtime)
      fd = create(:function_definition, runtime_function_definition: rfd)
      rpd = create(
        :runtime_parameter_definition,
        runtime_function_definition: rfd
      )
      pd = create(
        :parameter_definition,
        function_definition: fd,
        runtime_parameter_definition: rpd
      )

      func = create(
        :node_function,
        function_definition: fd,
        flow: flow,
        node_parameters: [
          create(
            :node_parameter,
            parameter_definition: pd
          )
        ]
      )

      flow.update!(starting_node: func)
    end

    it 'matches the model' do
      grpc_object = flow.to_grpc

      starting_node = flow.starting_node
      parameter_definition = starting_node.node_parameters.first.parameter_definition

      expect(grpc_object.to_h).to eq(
        {
          flow_id: flow.id,
          project_id: flow.project.id,
          project_slug: flow.project.slug,
          type: flow.flow_type.identifier,
          input_type: flow.input_type,
          return_type: flow.return_type,
          node_functions: [
            {
              database_id: starting_node.id,
              runtime_function_id: starting_node.function_definition.runtime_function_definition.runtime_name,
              parameters: [
                {
                  database_id: starting_node.node_parameters.first.id,
                  runtime_parameter_id: parameter_definition.runtime_parameter_definition.runtime_name,
                  value: {
                    literal_value: {
                      string_value: starting_node.node_parameters.first.literal_value,
                    },
                  },
                }
              ],
            }
          ],
          starting_node_id: starting_node.id,
          settings: [
            database_id: flow.flow_settings.first.id,
            flow_setting_id: flow.flow_settings.first.flow_setting_id,
            value: {
              struct_value: {
                fields: {
                  'url' => {
                    string_value: flow.flow_settings.first.object['url'],
                  },
                },
              },
            }
          ],
        }
      )
    end
  end
end
