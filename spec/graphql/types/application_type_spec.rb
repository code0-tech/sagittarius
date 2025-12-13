# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SagittariusSchema.types['Application'] do
  let(:fields) do
    %w[
      settings
      metadata
      privacyUrl
      termsAndConditionsUrl
      legalNoticeUrl
      user_abilities
    ]
  end

  it { expect(described_class.graphql_name).to eq('Application') }
  it { expect(described_class).to have_graphql_fields(fields) }
end
