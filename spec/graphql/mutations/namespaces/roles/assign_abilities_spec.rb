# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Namespaces::Roles::AssignAbilities do
  it { expect(described_class.graphql_name).to eq('NamespacesRolesAssignAbilities') }
end
