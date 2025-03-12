# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Namespaces::Roles::Delete do
  it { expect(described_class.graphql_name).to eq('NamespacesRolesDelete') }
end
