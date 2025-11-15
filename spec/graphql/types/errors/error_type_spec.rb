# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['Error'] do
  let(:fields) do
    %w[
      errorCode
      details
    ]
  end

  it { expect(described_class.graphql_name).to eq('Error') }
  it { expect(described_class).to have_graphql_fields(fields) }
end
