# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['License'] do
  let(:fields) do
    %w[
      id
      startDate
      endDate
      licensee
      userAbilities
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('License') }
  it { expect(described_class).to have_graphql_fields(fields).allow_unexpected_if_extended }
  it { expect(described_class).to require_graphql_authorizations(:read_license) }
end
