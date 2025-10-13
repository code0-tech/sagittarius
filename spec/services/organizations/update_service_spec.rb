# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::UpdateService do
  subject(:service_response) { described_class.new(create_authentication(current_user), organization, params).execute }

  shared_examples 'does not update' do
    it { is_expected.to be_error }

    it 'does not update organization' do
      expect { service_response }.not_to change { organization.reload.name }
    end

    it { expect { service_response }.not_to create_audit_event }
  end

  context 'when user does not exist' do
    let(:current_user) { nil }
    let(:organization) { create(:organization) }
    let(:params) do
      { name: generate(:organization_name) }
    end

    it_behaves_like 'does not update'
  end

  context 'when params are invalid' do
    let(:current_user) { create(:user) }
    let(:organization) { create(:organization) }

    before do
      stub_allowed_ability(OrganizationPolicy, :update_organization, user: current_user, subject: organization)
    end

    context 'when name is to long' do
      let(:params) { { name: generate(:organization_name) + ('*' * 50) } }

      it_behaves_like 'does not update'
    end

    context 'when name is to short' do
      let(:params) { { name: 'a' } }

      it_behaves_like 'does not update'
    end
  end

  context 'when user and params are valid' do
    let(:current_user) { create(:user) }
    let(:organization) { create(:organization) }
    let(:params) do
      { name: generate(:organization_name) }
    end

    before do
      stub_allowed_ability(OrganizationPolicy, :update_organization, user: current_user, subject: organization)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it 'updates organization' do
      expect { service_response }.to change { organization.reload.name }.from(organization.name).to(params[:name])
    end

    it do
      is_expected.to create_audit_event(
        :organization_updated,
        author_id: current_user.id,
        entity_type: 'Organization',
        details: { name: params[:name] },
        target_type: 'Namespace'
      )
    end
  end
end
