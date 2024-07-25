# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Users::Mfa::Totp::GenerateSecret do
  it { expect(described_class.graphql_name).to eq('UsersMfaTotpGenerateSecret') }
end
