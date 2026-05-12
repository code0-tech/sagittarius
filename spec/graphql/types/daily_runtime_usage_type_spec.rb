# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['DailyRuntimeUsage'] do
  let(:fields) do
    %w[
      id
      day
      flow
      namespace
      usage
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('DailyRuntimeUsage') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_namespace) }
end
