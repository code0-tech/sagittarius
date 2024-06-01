# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrganizationProjects::UpdateService do
  subject(:service_response) { described_class.new(current_user, organization_project, **params).execute }

  let(:organization) { create(:organization) }
  let(:organization_project) { create(:organization_project, organization: organization) }
  let(:organization_project_name) { generate(:organization_project_name) }
  let(:params) { { name: organization_project_name } }

  context 'when user is nil' do
    let(:current_user) { nil }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { organization_project.reload.name } }

    it do
      expect { service_response }.not_to create_audit_event(:organization_project_updated)
    end
  end

  context 'when user is not a member' do
    let(:current_user) { create(:user) }

    it { is_expected.not_to be_success }
    it { expect(service_response.payload).to eq(:missing_permission) }
    it { expect { service_response }.not_to change { organization_project.reload.name } }

    it do
      expect { service_response }.not_to create_audit_event(:organization_project_updated)
    end
  end

  context 'when user is a member' do
    let(:current_user) { create(:user) }

    before do
      create(:organization_member, organization: organization_project.organization, user: current_user)
      stub_allowed_ability(OrganizationProjectPolicy, :update_organization_project, user: current_user,
                                                                                    subject: organization_project)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.name).to eq(organization_project_name) }

    it do
      expect do
        service_response
      end.to change { organization_project.reload.name }.from(organization_project.name).to(params[:name])
    end

    it do
      expect { service_response }.to create_audit_event(
        :organization_project_updated,
        author_id: current_user.id,
        entity_id: organization_project.id,
        entity_type: 'OrganizationProject',
        details: { name: organization_project_name },
        target_id: organization_project.id,
        target_type: 'OrganizationProject'
      )
    end
  end
end
