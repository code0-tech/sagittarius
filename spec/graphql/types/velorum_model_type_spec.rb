# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::VelorumModelType do
  let(:fields) do
    %w[
      identifier
      name
      token_cost
      types
    ]
  end

  it { expect(described_class.graphql_name).to eq('VelorumModel') }
  it { expect(described_class).to have_graphql_fields(fields) }
end
