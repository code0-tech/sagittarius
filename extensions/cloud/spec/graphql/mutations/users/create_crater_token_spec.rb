# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Users::CreateCraterToken do
  it { expect(described_class.graphql_name).to eq('UsersCreateCraterToken') }
end
