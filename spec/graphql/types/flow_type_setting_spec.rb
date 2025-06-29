# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['FlowTypeSetting'] do
  let(:fields) do
    %w[
      identifier
      unique
      flow_type
      data_type
      names
      descriptions
      id
      created_at
      updated_at
    ]
  end

  it { expect(described_class.graphql_name).to eq('FlowTypeSetting') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_flow_type_setting) }
end
