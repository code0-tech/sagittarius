# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::AiType do
  let(:fields) do
    %w[
      enabled
      models
    ]
  end

  it { expect(described_class.graphql_name).to eq('Ai') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_velorum_config) }
end
