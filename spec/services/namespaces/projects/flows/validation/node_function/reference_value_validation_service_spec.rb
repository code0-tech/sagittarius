# frozen_string_literal: true

require 'rails_helper'

Rspec.describe Namespaces::Projects::Flows::Validation::NodeFunction::ReferenceValueValidationService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), flow, first_node, reference_value).execute
  end

  let(:current_user) { create(:user) }
  let(:runtime) { create(:runtime) }
  let(:namespace_project) { create(:namespace_project, primary_runtime: runtime) }
  let(:flow) { create(:flow, project: namespace_project, starting_node: first_node) }

  let(:first_node) do
    create(
      :node_function,
      function_definition: create(
        :function_definition,
        runtime_function_definition: create(:runtime_function_definition, runtime: runtime)
      ),
      node_parameters: [
        create(
          :node_parameter,
          parameter_definition: create(
            :parameter_definition,
            data_type: data_type_identifier
          ),
          literal_value: nil,
          function_value: create(:node_function)
        )
      ],
      next_node: second_node
    )
  end
  let(:second_node) do
    create(
      :node_function,
      function_definition: create(
        :function_definition,
        runtime_function_definition: create(:runtime_function_definition, runtime: runtime)
      ),
      node_parameters: [
        create(
          :node_parameter,
          parameter_definition: create(
            :parameter_definition,
            data_type: data_type_identifier
          ),
          literal_value: nil,
          function_value: create(
            :node_function,
            node_parameters: [
              create(
                :node_parameter,
                parameter_definition: create(
                  :parameter_definition,
                  data_type: data_type_identifier
                )
              )
            ]
          )
        ),
        create(
          :node_parameter,
          parameter_definition: create(
            :parameter_definition,
            data_type: data_type_identifier
          ),
          literal_value: nil,
          function_value: create(:node_function)
        )
      ]
    )
  end
  let(:data_type_identifier) do
    create(:data_type_identifier, data_type: create(:data_type, runtime: runtime), runtime: runtime)
  end
  let(:reference_value) do
    create(:reference_value,
           node_function: create(:node_function))
  end

  it { is_expected.to be_empty }
end
