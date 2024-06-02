# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::OrganizationProjects::Delete do
  it { expect(described_class.graphql_name).to eq('OrganizationProjectsDelete') }
end
