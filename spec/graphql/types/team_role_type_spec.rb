# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['TeamRole'] do
  let(:fields) do
    %w[
      id
      team
      name
      abilities
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('TeamRole') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_team_role) }
end
