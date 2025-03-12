# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::Namespaces::Members::Invite do
  it { expect(described_class.graphql_name).to eq('NamespacesMembersInvite') }
end
