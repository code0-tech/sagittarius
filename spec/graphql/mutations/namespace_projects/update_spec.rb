# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::NamespaceProjects::Update do
  it { expect(described_class.graphql_name).to eq('NamespaceProjectsUpdate') }
end
