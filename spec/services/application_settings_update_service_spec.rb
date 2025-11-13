# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationSettingsUpdateService do
  subject(:service_response) { described_class.new(create_authentication(current_user), params).execute }

  context 'when user is nil' do
    let(:current_user) { nil }
    let(:params) { { user_registration_enabled: false } }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload[:error_code]).to eq(:missing_permission) }

    it 'does not change any settings' do
      expect { service_response }.not_to change { ApplicationSetting.pluck(:value) }
    end

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user is not an admin' do
    let(:current_user) { create(:user) }
    let(:params) { { user_registration_enabled: false } }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload[:error_code]).to eq(:missing_permission) }

    it 'does not change any settings' do
      expect { service_response }.not_to change { ApplicationSetting.pluck(:value) }
    end

    it do
      expect { service_response }.not_to create_audit_event
    end
  end

  context 'when user is an admin' do
    let(:current_user) { create(:user, :admin) }
    let(:params) { { user_registration_enabled: false } }

    it { is_expected.to be_success }
    it { expect(service_response.payload).to include(user_registration_enabled: false) }

    it 'changes the setting' do
      expect { service_response }.to change {
                                       ApplicationSetting.current[:user_registration_enabled]
                                     }.from(true).to(false)
    end

    it do
      expect { service_response }.to create_audit_event(
        :application_setting_updated,
        author_id: current_user.id,
        entity_type: 'ApplicationSetting',
        details: { setting: 'user_registration_enabled', value: false },
        target_type: 'ApplicationSetting'
      )
    end
  end
end
