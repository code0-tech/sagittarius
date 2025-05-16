# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['Query'] do
  let(:fields) do
    %w[
      applicationSettings
      currentAuthentication
      currentUser
      echo
      organization
      users
      global_runtimes
      namespace
      node
      nodes
      flow_types
    ]
  end

  it { expect(described_class.graphql_name).to eq('Query') }
  it { expect(described_class).to have_graphql_fields(fields) }
end
