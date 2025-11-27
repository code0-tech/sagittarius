# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::CreateService do
  subject(:service_response) do
    described_class.new(create_authentication(current_user), **params).execute
  end

  let!(:current_user) { create(:user, :admin) }
  let(:params) do
    {
      email: generate(:email),
      username: generate(:username),
      password: 'Password123!',
      firstname: 'Test',
      lastname: 'User',
      admin: false,
    }
  end

  shared_examples 'does not create' do
    it { is_expected.to be_error }

    it 'does not create user' do
      expect { service_response }.not_to change { User.count }
    end

    it { expect { service_response }.not_to create_audit_event }
  end

  context 'when not authenticated' do
    let(:current_user) { nil }

    it_behaves_like 'does not create'
  end

  context 'when params are invalid' do
    context 'when email is invalid' do
      let(:params) do
        {
          email: 'invalid-email',
          username: generate(:username),
          password: 'pw',
          firstname: 'T',
          lastname: 'U',
          admin: false,
        }
      end

      it_behaves_like 'does not create'
    end

    context 'when username is too long' do
      let(:params) do
        {
          email: generate(:email),
          username: 'a' * 100,
          password: 'Password123!',
          firstname: 'T',
          lastname: 'U',
          admin: false,
        }
      end

      it_behaves_like 'does not create'
    end
  end

  context 'when user and params are valid and user is admin' do
    let(:params) do
      {
        email: generate(:email),
        username: generate(:username),
        password: 'Password123!',
        firstname: 'First',
        lastname: 'Last',
        admin: true,
      }
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload.reload).to be_valid }

    it do
      is_expected.to create_audit_event(
        :user_created,
        author_id: current_user.id,
        entity_type: 'User',
        details: {
          'email' => params[:email],
          'username' => params[:username],
          'firstname' => params[:firstname],
          'lastname' => params[:lastname],
          'admin' => params[:admin],
        },
        target_type: 'global'
      )
    end
  end
end
