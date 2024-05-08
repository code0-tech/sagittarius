# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationLicenses::CreateService do
  subject(:service_response) { described_class.new(current_user, **params).execute }

  let(:organization) { create(:organization) }

  shared_examples 'does not create' do
    it { is_expected.to be_error }

    it 'does not create organization' do
      expect { service_response }.not_to change { OrganizationLicense.count }
    end

    it { expect { service_response }.not_to create_audit_event(:organization_license_created) }
  end

  context 'when user does not exist' do
    let(:current_user) { nil }
    # rubocop:disable RSpec/LetSetup
    let!(:params) do
      { data: create(:organization_license).data, organization: organization }
    end

    it_behaves_like 'does not create'
  end

  context 'when params are invalid' do
    let(:current_user) { create(:user) }

    context 'when data is invalid' do
      let(:params) { { data: '', organization: create(:organization) } }

      it_behaves_like 'does not create'
    end

    context 'when organization is invalid' do
      let!(:params) { { data: create(:organization_license).data, organization: nil } }
      # rubocop:enable RSpec/LetSetup

      it_behaves_like 'does not create'
    end
  end

  context 'when user and params are valid' do
    let(:current_user) { create(:user) }
    let(:license_data) do
      {
        licensee: { 'company' => 'Code0' },
        start_date: (Time.zone.today - 1).to_s,
        end_date: (Time.zone.today + 1).to_s,
        restrictions: {},
        options: {},
      }
    end

    # rubocop:disable RSpec/LetSetup
    let!(:params) do
      { data: create(:organization_license, **license_data).data, organization: organization }
    end
    # rubocop:enable RSpec/LetSetup

    before do
      stub_allowed_ability(OrganizationPolicy, :create_organization_license, user: current_user, subject: organization)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it 'adds license to the organization' do
      expect { service_response }.to change { OrganizationLicense.where(organization: organization).count }.by(1)
    end

    it do
      is_expected.to create_audit_event(
        :organization_license_created,
        author_id: current_user.id,
        entity_type: 'OrganizationLicense',
        details: license_data,
        target_type: 'Organization'
      )
    end
  end
end
