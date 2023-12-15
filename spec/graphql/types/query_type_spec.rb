# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['Query'] do
  let(:fields) do
    %w[
      currentAuthorization
      currentUser
      echo
      node
      nodes
    ]
  end

  it { expect(described_class.graphql_name).to eq('Query') }
  it { expect(described_class).to have_graphql_fields(fields) }
end
