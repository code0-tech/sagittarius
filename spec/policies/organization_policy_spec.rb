# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationPolicy do
  subject { described_class.new(create_authentication(current_user), organization) }

  let(:current_user) { nil }
  let(:organization) { create(:organization) }

  context 'when user can read namespace' do
    let(:current_user) { create(:user) }

    before do
      create(:namespace_member, user: current_user, namespace: organization.ensure_namespace)
    end

    it { is_expected.to be_allowed(:read_organization) }
  end

  it { is_expected.not_to be_allowed(:read_organization) }
end
