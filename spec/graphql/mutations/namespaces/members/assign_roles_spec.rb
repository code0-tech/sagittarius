# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Namespaces::Members::AssignRoles do
  it { expect(described_class.graphql_name).to eq('NamespacesMembersAssignRoles') }
end
