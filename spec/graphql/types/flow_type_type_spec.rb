# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['FlowType'] do
  let(:fields) do
    %w[
      identifier
      editable
      input_type
      return_type
      flow_type_settings
      names
      display_messages
      aliases
      descriptions
      id
      created_at
      updated_at
    ]
  end

  it { expect(described_class.graphql_name).to eq('FlowType') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_flow_type) }
end
