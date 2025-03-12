# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Namespaces::Projects::Update do
  it { expect(described_class.graphql_name).to eq('NamespacesProjectsUpdate') }
end
