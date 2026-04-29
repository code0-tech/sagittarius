# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Licenses::CreateService, unless: Sagittarius::Extensions.cloud? do
  subject(:service_response) { described_class.new(create_authentication(current_user), **params).execute }

  shared_examples 'does not create' do
    it { is_expected.to be_error }

    it 'does not create namespace license' do
      expect { service_response }.not_to change { License.count }
    end

    it { expect { service_response }.not_to create_audit_event }
  end

  context 'when user does not exist' do
    let(:current_user) { nil }
    # rubocop:disable RSpec/LetSetup
    let!(:params) do
      { data: create(:license).data }
    end

    it_behaves_like 'does not create'
  end

  context 'when params are invalid' do
    let(:current_user) { create(:user, :admin) }

    let(:params) { { data: '' } }

    it_behaves_like 'does not create'
  end

  context 'when user does not have permission' do
    let(:current_user) { create(:user) }

    let!(:params) do
      { data: create(:license).data }
    end

    it_behaves_like 'does not create'
  end

  context 'when user and params are valid' do
    let(:current_user) { create(:user, :admin) }
    let(:license_data) do
      {
        licensee: { 'company' => 'Code0' },
        start_date: (Time.zone.today - 1).to_s,
        end_date: (Time.zone.today + 1).to_s,
        restrictions: {},
        options: {},
      }
    end

    let!(:params) do
      { data: create(:license, **license_data).data }
    end
    # rubocop:enable RSpec/LetSetup

    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it 'adds license to the namespace' do
      expect { service_response }.to change { License.count }.by(1)
    end

    it do
      is_expected.to create_audit_event(
        :license_created,
        author_id: current_user.id,
        entity_type: 'License',
        details: license_data,
        target_id: 0,
        target_type: 'global'
      )
    end
  end
end
