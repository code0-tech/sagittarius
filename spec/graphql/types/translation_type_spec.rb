# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['Translation'] do
  let(:fields) do
    %w[
      code
      content
    ]
  end

  it { expect(described_class.graphql_name).to eq('Translation') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_translation) }
end
