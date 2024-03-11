# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['ApplicationSettings'] do
  let(:fields) do
    %w[
      userRegistrationEnabled
      organizationCreationRestricted
    ]
  end

  it { expect(described_class.graphql_name).to eq('ApplicationSettings') }
  it { expect(described_class).to have_graphql_fields(fields) }
  it { expect(described_class).to require_graphql_authorizations(:read_application_setting) }
end
