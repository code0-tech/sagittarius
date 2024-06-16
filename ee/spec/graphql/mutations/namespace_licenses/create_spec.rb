# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::NamespaceLicenses::Create do
  it { expect(described_class.graphql_name).to eq('NamespaceLicensesCreate') }
end
