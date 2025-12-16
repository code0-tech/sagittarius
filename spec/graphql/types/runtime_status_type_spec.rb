# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['RuntimeStatus'] do
  let(:fields) do
    %w[
      id
      status
      configurations
      featureSet
      lastHeartbeat
      type
      identifier
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('RuntimeStatus') }
  it { expect(described_class).to have_graphql_fields(fields) }
end
