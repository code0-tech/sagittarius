# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::MetadataType do
  let(:fields) do
    %w[
      version
      extensions
    ]
  end

  it { expect(described_class.graphql_name).to eq('Metadata') }
  it { expect(described_class).to have_graphql_fields(fields) }
end
