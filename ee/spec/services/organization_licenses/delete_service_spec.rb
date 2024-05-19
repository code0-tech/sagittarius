# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationLicenses::DeleteService do
  subject(:service_response) { described_class.new(current_user, **params).execute }

  let(:organization) { create(:organization) }

  shared_examples 'does not delete' do
    it { is_expected.to be_error }

    it 'does not delete organization' do
      expect { service_response }.not_to change { OrganizationLicense.count }
    end

    it { expect { service_response }.not_to create_audit_event(:organization_license_deleted) }
  end

  context 'when user does not exist' do
    let(:current_user) { nil }
    # rubocop:disable RSpec/LetSetup
    let!(:params) do
      { organization_license: create(:organization_license), organization: organization }
    end

    it_behaves_like 'does not delete'
  end

  context 'when params are invalid' do
    let(:current_user) { create(:user) }

    context 'when data is invalid' do
      let(:params) { { organization_license: nil, organization: create(:organization) } }

      it_behaves_like 'does not delete'
    end

    context 'when organization is invalid' do
      let!(:params) { { organization_license: create(:organization_license), organization: nil } }
      # rubocop:enable RSpec/LetSetup

      it_behaves_like 'does not delete'
    end
  end

  context 'when user and params are valid' do
    let(:current_user) { create(:user) }
    let!(:organization_license) { create(:organization_license, organization: organization) }

    # rubocop:disable RSpec/LetSetup
    let!(:params) do
      { organization_license: organization_license, organization: organization }
    end
    # rubocop:enable RSpec/LetSetup

    before do
      stub_allowed_ability(OrganizationPolicy, :delete_organization_license, user: current_user, subject: organization)
    end

    it { is_expected.to be_success }

    it 'removes license to the organization' do
      expect { service_response }.to change { OrganizationLicense.where(organization: organization).count }.by(-1)
    end

    it do
      is_expected.to create_audit_event(
        :organization_license_deleted,
        author_id: current_user.id,
        entity_type: 'OrganizationLicense',
        details: {},
        target_type: 'Organization'
      )
    end
  end
end
