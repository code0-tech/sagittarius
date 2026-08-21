# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Types::ApplicationType do
  let(:fields) do
    %w[
      settings
      metadata
      privacyUrl
      termsAndConditionsUrl
      legalNoticeUrl
      licenses
      currentLicense
      identityProviders
      identityProviderLoginUrl
      runtimeUsage
      aiUsage
      user_abilities
    ]
  end

  it { expect(described_class).to include_module(EE::Types::ApplicationType) }

  it { expect(described_class.graphql_name).to eq('Application') }
  it { expect(described_class).to have_graphql_fields(fields) }
end
