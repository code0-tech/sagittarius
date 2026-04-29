# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Licenses::DeleteService, unless: Sagittarius::Extensions.cloud? do
  subject(:service_response) { described_class.new(create_authentication(current_user), **params).execute }

  shared_examples 'does not delete' do
    it { is_expected.to be_error }

    it 'does not delete namespace license' do
      expect { service_response }.not_to change { License.count }
    end

    it { expect { service_response }.not_to create_audit_event }
  end

  context 'when user does not exist' do
    let(:current_user) { nil }
    # rubocop:disable RSpec/LetSetup
    let!(:params) do
      { license: create(:license) }
    end

    it_behaves_like 'does not delete'
  end

  context 'when user and params are valid' do
    let(:current_user) { create(:user, :admin) }
    let!(:license) { create(:license) }

    let!(:params) do
      { license: license }
    end
    # rubocop:enable RSpec/LetSetup

    it { is_expected.to be_success }

    it 'removes license to the namespace' do
      expect { service_response }.to change { License.count }.by(-1)
    end

    it do
      is_expected.to create_audit_event(
        :license_deleted,
        author_id: current_user.id,
        entity_type: 'License',
        details: {},
        target_id: 0,
        target_type: 'global'
      )
    end
  end
end
