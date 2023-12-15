# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['User'] do
  let(:fields) do
    %w[
      id
      username
      email
      createdAt
      updatedAt
    ]
  end

  it { expect(described_class.graphql_name).to eq('User') }
  it { expect(described_class).to have_graphql_fields(fields) }
end
