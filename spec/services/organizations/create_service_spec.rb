# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organizations::CreateService do
  subject(:service_response) { described_class.new(current_user, **params).execute }

  shared_examples 'does not create' do
    it { is_expected.to be_error }

    it 'does not create organization' do
      expect { service_response }.not_to change { Organization.count }
    end

    it 'does not create organization member' do
      expect { service_response }.not_to change { OrganizationMember.count }
    end

    it { expect { service_response }.not_to create_audit_event(:organization_created) }
  end

  context 'when user does not exist' do
    let(:current_user) { nil }
    let(:params) do
      { name: generate(:organization_name) }
    end

    it_behaves_like 'does not create'
  end

  context 'when params are invalid' do
    let(:current_user) { create(:user) }

    context 'when name is to long' do
      let(:params) { { name: generate(:organization_name) + ('*' * 50) } }

      it_behaves_like 'does not create'
    end

    context 'when name is to short' do
      let(:params) { { name: 'a' } }

      it_behaves_like 'does not create'
    end
  end

  context 'when user and params are valid' do
    let(:current_user) { create(:user) }
    let(:params) do
      { name: generate(:organization_name) }
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it 'adds current_user as organization member' do
      organization = service_response.payload.reload
      member = OrganizationMember.find_by(organization: organization, user: current_user)

      expect(member).to be_present
    end

    it 'adds ability to the current_user' do
      organization = service_response.payload.reload
      expect(Ability.allowed?(current_user, :assign_role_abilities, organization)).to be(true)
    end

    it 'creates ability' do
      expect { service_response }.to change { OrganizationRoleAbility.count }.by(1)
    end

    it 'creates role' do
      expect { service_response }.to change { OrganizationRole.count }.by(1)
    end

    it 'only adds 1 member' do
      expect { service_response }.to change { OrganizationMember.count }.by(1)
    end

    it do
      is_expected.to create_audit_event(
        :organization_created,
        author_id: current_user.id,
        entity_type: 'Organization',
        details: { name: params[:name] },
        target_type: 'Organization'
      )
    end
  end
end
