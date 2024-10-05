# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Users::Identity::Login do
  it { expect(described_class.graphql_name).to eq('UsersIdentityLogin') }
end
