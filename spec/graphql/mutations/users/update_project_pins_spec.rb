# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Users::UpdateProjectPins do
  it { expect(described_class.graphql_name).to eq('UsersUpdateProjectPins') }
end
