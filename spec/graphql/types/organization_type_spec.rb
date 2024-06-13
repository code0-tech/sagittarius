# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['Organization'] do
  let(:fields) do
    %w[
      id
      name
      namespace
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('Organization') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_organization) }
end
