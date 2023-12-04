# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Users::Register do
  it { expect(described_class.graphql_name).to eq('UsersRegister') }
end
