# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['LicenseOptions'] do
  let(:fields) do
    %w[
      customerType
      paymentPeriod
      plan
    ]
  end

  it { expect(described_class.graphql_name).to eq('LicenseOptions') }
  it { expect(described_class).to have_graphql_fields(fields) }
end
