# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Users::Identity::Unlink do
  it { expect(described_class.graphql_name).to eq('UsersIdentityUnlink') }
end
