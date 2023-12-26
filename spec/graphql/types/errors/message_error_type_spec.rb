# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['MessageError'] do
  let(:fields) do
    %w[
      message
    ]
  end

  it { expect(described_class.graphql_name).to eq('MessageError') }
  it { expect(described_class).to have_graphql_fields(fields) }
end
