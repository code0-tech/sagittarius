# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationProjects::CreateService do
  subject(:service_response) { described_class.new(current_user, **params).execute }

  let(:organization) { create(:organization) }

  shared_examples 'does not create' do
    it { is_expected.to be_error }

    it 'does not create project' do
      expect { service_response }.not_to change { OrganizationProject.count }
    end

    it { expect { service_response }.not_to create_audit_event(:organization_created) }
  end

  context 'when user does not exist' do
    let(:current_user) { nil }
    let(:params) do
      { organization: organization, name: generate(:organization_project_name) }
    end

    it_behaves_like 'does not create'
  end

  context 'when params are invalid' do
    let(:current_user) { create(:user) }

    context 'when name is to long' do
      let(:params) { { organization: organization, name: generate(:organization_project_name) + ('*' * 50) } }

      it_behaves_like 'does not create'
    end

    context 'when name is to short' do
      let(:params) { { organization: organization, name: 'a' } }

      it_behaves_like 'does not create'
    end
  end

  context 'when user and params are valid' do
    let(:current_user) { create(:user) }
    let(:params) do
      { organization: organization, name: generate(:organization_project_name) }
    end

  before do
      stub_allowed_ability(OrganizationPolicy, :create_organization_project, user: current_user, subject: organization)
  end

    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it do
      is_expected.to create_audit_event(
        :organization_project_created,
        author_id: current_user.id,
        entity_type: 'OrganizationProject',
        details: {
          name: params[:name],
        },
        target_type: 'Organization'
      )
    end
  end
end
