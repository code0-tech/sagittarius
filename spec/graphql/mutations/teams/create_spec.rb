# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Teams::Create do
  it { expect(described_class.graphql_name).to eq('TeamsCreate') }
end
