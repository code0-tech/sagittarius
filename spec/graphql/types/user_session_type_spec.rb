# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['UserSession'] do
  let(:fields) do
    %w[
      id
      user
      token
      active
    ]
  end

  it { expect(described_class.graphql_name).to eq('UserSession') }
  it { expect(described_class).to have_graphql_fields(fields) }
end
