# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationProjectPolicy do
  subject { described_class.new(current_user, organization_project) }

  let(:current_user) { create(:user) }
  let(:organization_project) { create(:organization_project) }

  context 'when user can create projects in organization' do
    before do
      stub_allowed_ability(
        OrganizationPolicy,
        :create_organization_project,
        user: current_user,
        subject: organization_project.organization
      )
    end

    it { is_expected.to be_allowed(:read_organization_project) }
  end
end
