# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Namespaces::Projects::CreateService do
  subject(:service_response) { described_class.new(create_authentication(current_user), **params).execute }

  let(:namespace) { create(:namespace) }

  shared_examples 'does not create' do
    it { is_expected.to be_error }

    it 'does not create project' do
      expect { service_response }.not_to change { NamespaceProject.count }
    end

    it { expect { service_response }.not_to create_audit_event }
  end

  context 'when user does not exist' do
    let(:current_user) { nil }
    let(:params) do
      { namespace: namespace, name: generate(:namespace_project_name) }
    end

    it_behaves_like 'does not create'
  end

  context 'when params are invalid' do
    let(:current_user) { create(:user) }

    context 'when name is to long' do
      let(:params) { { namespace: namespace, name: generate(:namespace_project_name) + ('*' * 50) } }

      it_behaves_like 'does not create'
    end

    context 'when name is to short' do
      let(:params) { { namespace: namespace, name: 'a' } }

      it_behaves_like 'does not create'
    end
  end

  context 'when user and params are valid' do
    let(:current_user) { create(:user) }
    let(:params) do
      { namespace: namespace, name: generate(:namespace_project_name) }
    end

    before do
      stub_allowed_ability(NamespacePolicy, :create_namespace_project, user: current_user, subject: namespace)
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it do
      is_expected.to create_audit_event(
        :namespace_project_created,
        author_id: current_user.id,
        entity_type: 'NamespaceProject',
        details: {
          name: params[:name],
          slug: service_response.payload.slug,
        },
        target_id: namespace.id,
        target_type: 'Namespace'
      )
    end

    context 'when slug is duplicated' do
      let(:params) do
        { namespace: namespace, name: generate(:namespace_project_name), slug: 'some-slug' }
      end

      before do
        create(:namespace_project, slug: 'some-slug')
      end

      it 'fails to create project' do
        expect(service_response).to be_error
        expect(service_response.payload[:error_code]).to eq(:invalid_namespace_project)
      end

      context 'when slug is not set' do
        let(:params) do
          { namespace: namespace, name: generate(:namespace_project_name) }
        end

        before do
          create(:namespace_project, slug: params[:name].parameterize)
        end

        it 'creates project with unique slug' do
          expect(service_response).to be_success
          expect(service_response.payload.reload).to be_valid
          expect(service_response.payload.slug).not_to eq(params[:name].parameterize)
          expect(service_response.payload.slug).to match(/^#{params[:name].parameterize}-[a-f0-9]{8}$/)
        end
      end
    end

    context 'when only one global runtime exists' do
      let!(:global_runtime) { create(:runtime, namespace: nil) }

      context 'when user has permission to assign runtimes' do
        before do
          stub_allowed_ability(
            NamespaceProjectPolicy, :assign_project_runtimes,
            user: current_user, subject: an_instance_of(NamespaceProject)
          )
        end

        it 'assigns the global runtime as the primary runtime' do
          service_response
          expect(service_response.payload.primary_runtime).to eq(global_runtime)
        end

        it 'assigns the global runtime to the project' do
          service_response
          expect(service_response.payload.runtimes).to contain_exactly(global_runtime)
        end
      end

      context 'when user does not have permission to assign runtimes' do
        it 'does not assign a primary runtime' do
          service_response
          expect(service_response.payload.primary_runtime).to be_nil
        end
      end
    end

    context 'when multiple global runtimes exist' do
      before do
        create(:runtime, namespace: nil)
        create(:runtime, namespace: nil)
      end

      it 'does not assign a primary runtime' do
        service_response
        expect(service_response.payload.primary_runtime).to be_nil
      end
    end

    context 'when no global runtime exists and namespace has exactly one runtime' do
      let!(:namespace_runtime) { create(:runtime, namespace: namespace) }

      before do
        stub_allowed_ability(
          NamespaceProjectPolicy, :assign_project_runtimes,
          user: current_user, subject: an_instance_of(NamespaceProject)
        )
      end

      it 'assigns the namespace runtime as the primary runtime' do
        service_response
        expect(service_response.payload.primary_runtime).to eq(namespace_runtime)
      end

      it 'assigns the namespace runtime to the project' do
        service_response
        expect(service_response.payload.runtimes).to contain_exactly(namespace_runtime)
      end
    end

    context 'when no global runtime exists and namespace has multiple runtimes' do
      before do
        create(:runtime, namespace: namespace)
        create(:runtime, namespace: namespace)
      end

      it 'does not assign a primary runtime' do
        service_response
        expect(service_response.payload.primary_runtime).to be_nil
      end
    end

    context 'when a global runtime exists and the namespace also has a runtime' do
      before do
        create(:runtime, namespace: nil)
        create(:runtime, namespace: namespace)
        stub_allowed_ability(
          NamespaceProjectPolicy, :assign_project_runtimes,
          user: current_user, subject: an_instance_of(NamespaceProject)
        )
      end

      it 'does not assign a primary runtime' do
        service_response
        expect(service_response.payload.primary_runtime).to be_nil
      end
    end
  end
end
