# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Users::PasswordResetRequest do
  it { expect(described_class.graphql_name).to eq('UsersPasswordResetRequest') }
end
