# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Namespaces::Roles::AssignProjects do
  it { expect(described_class.graphql_name).to eq('NamespacesRolesAssignProjects') }
end
