# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['NamespaceLicense'] do
  let(:fields) do
    %w[
      namespace
      id
      startDate
      endDate
      licensee
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('NamespaceLicense') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_namespace_license) }
end
