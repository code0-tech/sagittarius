# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Users::Delete do
  it { expect(described_class.graphql_name).to eq('UsersDelete') }
end
