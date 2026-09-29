# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::SetActiveSubscriptionService do
  subject(:service_response) { described_class.new(authentication, user, active: active).execute }

  let(:user) { create(:user) }

  context 'when the current authentication is not crater' do
    let(:authentication) { create_authentication(create(:user)) }
    let(:active) { true }

    it { is_expected.to be_error }
    it { expect(service_response.payload[:error_code]).to eq(:missing_permission) }

    it 'does not create a custom attribute' do
      expect { service_response }.not_to change { user.user_custom_attributes.count }
    end

    it { expect { service_response }.not_to create_audit_event }
  end

  context 'when the current authentication is crater' do
    let(:crater_user) { create(:user, :crater) }
    let(:authentication) do
      Sagittarius::Authentication.new(:crater, CLOUD::ApplicationController::CraterToken.new(user: crater_user))
    end

    context 'when setting active to true' do
      let(:active) { true }

      it { is_expected.to be_success }

      it 'creates the active_subscription custom attribute' do
        service_response

        expect(user.user_custom_attributes.find_by(key: 'active_subscription').value).to be(true)
      end

      it do
        is_expected.to create_audit_event(
          :user_custom_attribute_updated,
          author_id: crater_user.id,
          entity_id: user.id,
          entity_type: 'User',
          details: { key: 'active_subscription', active: true }
        )
      end

      context 'when the attribute already exists' do
        before { create(:user_custom_attribute, user: user, key: 'active_subscription', value: 'pending') }

        it 'does not create a duplicate' do
          expect { service_response }.not_to change { user.user_custom_attributes.count }
        end

        it 'updates the value' do
          service_response

          expect(user.user_custom_attributes.find_by(key: 'active_subscription').value).to be(true)
        end
      end
    end

    context 'when setting active to false' do
      let(:active) { false }

      context 'when the attribute exists' do
        before { create(:user_custom_attribute, user: user, key: 'active_subscription', value: true) }

        it { is_expected.to be_success }

        it 'removes the custom attribute' do
          expect { service_response }.to change { user.user_custom_attributes.count }.by(-1)
        end

        it do
          is_expected.to create_audit_event(
            :user_custom_attribute_updated,
            author_id: crater_user.id,
            entity_id: user.id,
            entity_type: 'User',
            details: { key: 'active_subscription', active: false }
          )
        end
      end

      context 'when the attribute does not exist' do
        it { is_expected.to be_success }

        it 'does not change the custom attribute count' do
          expect { service_response }.not_to change { user.user_custom_attributes.count }
        end
      end
    end
  end
end
