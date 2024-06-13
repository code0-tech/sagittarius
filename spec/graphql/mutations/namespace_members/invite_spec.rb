# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::NamespaceMembers::Invite do
  it { expect(described_class.graphql_name).to eq('NamespaceMembersInvite') }
end
