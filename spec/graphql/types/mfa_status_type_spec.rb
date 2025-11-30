# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['MfaStatus'] do
  let(:fields) do
    %w[
      enabled
      totpEnabled
      backupCodesCount
    ]
  end

  it { expect(described_class.graphql_name).to eq('MfaStatus') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_mfa_status) }
end
