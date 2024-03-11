# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Mutations::OrganizationMembers::Invite do
  it { expect(described_class.graphql_name).to eq('OrganizationMembersInvite') }
end
