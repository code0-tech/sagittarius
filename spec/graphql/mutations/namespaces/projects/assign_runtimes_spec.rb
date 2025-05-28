# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Namespaces::Projects::AssignRuntimes do
  it { expect(described_class.graphql_name).to eq('NamespacesProjectsAssignRuntimes') }
end
