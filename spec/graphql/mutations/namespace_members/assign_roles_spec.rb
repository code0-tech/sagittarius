# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::NamespaceMembers::AssignRoles do
  it { expect(described_class.graphql_name).to eq('NamespaceMembersAssignRoles') }
end
