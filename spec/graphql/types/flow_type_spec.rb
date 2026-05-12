# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['Flow'] do
  let(:fields) do
    %w[
      id
      dailyRuntimeUsages
      name
      disabledReason
      validationStatus
      project
      settings
      signature
      startingNodeId
      type
      nodes
      linkedDataTypes
      userAbilities
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('Flow') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_flow) }
end
