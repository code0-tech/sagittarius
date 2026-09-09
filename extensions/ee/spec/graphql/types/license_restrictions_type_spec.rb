# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['LicenseRestrictions'] do
  let(:fields) do
    %w[
      aiTokens
      userCount
      workflowExecutions
    ]
  end

  it { expect(described_class.graphql_name).to eq('LicenseRestrictions') }
  it { expect(described_class).to have_graphql_fields(fields) }
end
