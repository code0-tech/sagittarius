# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Users::Mfa::Totp::ValidateSecret do
  it { expect(described_class.graphql_name).to eq('UsersMfaTotpValidateSecret') }
end
