# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Users::Identity::Register do
  it { expect(described_class.graphql_name).to eq('UsersIdentityRegister') }
end
