# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::VelorumType do
  let(:fields) do
    %w[
      enabled
      models
    ]
  end

  it { expect(described_class.graphql_name).to eq('Velorum') }
  it { expect(described_class).to have_graphql_fields(fields) }
end
