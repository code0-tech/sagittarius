# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['Flow'] do
  let(:fields) do
    %w[
      name
      disabled_reason
      validation_status
      validation_message
      project
      settings
      signature
      starting_node_id
      type
      nodes
      execution_result
      execution_results
      linked_data_types
      user_abilities
      id
      created_at
      updated_at
    ]
  end

  it { expect(described_class.graphql_name).to eq('Flow') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_flow) }
end
