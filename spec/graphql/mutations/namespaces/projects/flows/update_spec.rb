# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Namespaces::Projects::Flows::Update do
  it { expect(described_class.graphql_name).to eq('NamespacesProjectsFlowsUpdate') }
end
