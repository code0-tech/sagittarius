# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Licenses::Delete do
  it { expect(described_class.graphql_name).to eq('LicensesDelete') }
end
