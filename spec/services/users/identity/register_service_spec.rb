# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::Identity::RegisterService do

  let(:service) {
    described_class.new(provider_id, args)
  }

  subject(:service_response) { service.execute }

  def setup_identity_provider(identity)
    provider = service.identity_provider
    allow(service).to receive(:identity_provider).and_return provider
    allow(provider).to receive(:load_identity).and_return identity
  end

  context 'when user is valid' do
    let(:provider_id) {
      :google
    }
    let(:args) {
      {
        code: "valid_code"
      }
    }

    before do
      setup_identity_provider Code0::Identities::Identity.new(provider_id, "identifier", "username", "test@code0.tech", "firstname", "lastname")
    end

    it { is_expected.to be_success }
    it { expect(service_response.payload).to be_valid }
    it('sets username correct') { expect(service_response.payload.username).to eq("username") }
    it('sets email correct') { expect(service_response.payload.email).to eq("test@code0.tech") }
    it('sets password correct') { expect(service_response.payload.password.length).to eq(50) }

    it 'creates the audit event' do
      expect { service_response }.to create_audit_event(
                                       :user_registered,
                                       entity_type: 'User',
                                       details: { "provider_id" => provider_id.to_s, "identifier" => "identifier" },
                                       target_type: 'User'
                                     )
    end

    context 'when user registration is disabled' do
      before do
        stub_application_settings(user_registration_enabled: false)
      end

      it { is_expected.not_to be_success }
      it { expect(service_response.message).to eq('User registration is disabled') }
      it { expect(service_response.payload).to eq(:registration_disabled) }
    end
  end

  shared_examples 'invalid user' do |error_message|
    it { is_expected.not_to be_success }
    it { expect(service_response.message).to eq(error_message) }
    it { expect { service_response }.not_to create_audit_event }
  end

  context 'when values are missing' do
    let(:provider_id) {
      :google
    }
    let(:args) {
      {
        code: "valid_code"
      }
    }

    context 'when email is nil' do
      before do
        setup_identity_provider Code0::Identities::Identity.new(provider_id, "identifier", "username", nil, "firstname", "lastname")
      end

      it "returns the right error" do
        expect(service_response.payload).to eq(:missing_identity_data)
      end

      it_behaves_like 'invalid user', "No email given"
    end

    context "when username is missing" do
      let(:email) { "test@code0.tech" }
      before do
        setup_identity_provider Code0::Identities::Identity.new(provider_id, "identifier", nil, email, "firstname", "lastname")
      end

      context 'when address name is not a duplicate' do

        it "gets the username out of the address name" do
          expect(service_response.payload.username).to eq("test")
          is_expected.to be_success
        end
      end

      context 'when address name is a duplicate' do
        before do
          create(:user, username: "test")
          allow(SecureRandom).to receive(:base36).with(1).and_return("a")
        end

        it "modifies the username to be not unique" do
          expect(service_response.payload.username).not_to eq("test")
          expect(service_response.payload.username).to eq("testa")
          expect(service_response.payload).not_to be_nil
          is_expected.to be_success
        end
      end

      context 'when address name is longer than 50 chars' do
        let(:username) {
          SecureRandom.base36(51)
        }
        let(:email) { "#{username}@code0.tech" }

        it "modifies the username to be not unique" do
          expect(service_response.payload.username).not_to eq(username)
          expect(service_response.payload.username).to eq(username[0..49])
          expect(service_response.payload).not_to be_nil
          is_expected.to be_success
        end

        context 'when shorter version is a duplicate' do
          let(:username) {
            SecureRandom.base36(51)
          }
          let(:email) { "#{username}@code0.tech" }
          before do
            create(:user, username: username[0..49])
            allow(SecureRandom).to receive(:base36).with(1).and_return("A")
            allow(SecureRandom).to receive(:base36).with(20).and_return("ABC")
          end

          it "modifies the username to be not unique" do
            expect(service_response.payload.username).not_to eq(username)
            expect(service_response.payload.username).to eq("ABC")
            expect(service_response.payload).not_to be_nil
            is_expected.to be_success
          end
        end
      end
    end
  end

  context 'when identity validation throws and error' do
    before do
      provider = service.identity_provider
      allow(service).to receive(:identity_provider).and_return provider
      allow(provider).to receive(:load_identity).and_raise(Code0::Identities::Error.new("Error message"))
    end

    let(:provider_id) { :google }
    let(:args) { {} }
    it "catches the error" do
      expect { service_response }.not_to raise_error
      expect(service_response.payload).to eq(:identity_validation_failed)
      expect(service_response.message).to eq("Error message")
    end

  end

  context 'when identity is already existing with same provider and identifier' do
    let(:existing_identity) { create(:user_identity) }
    let(:provider_id) { existing_identity.provider_id }
    let(:args) { {} }
    before do
      setup_identity_provider Code0::Identities::Identity.new(existing_identity.provider_id, existing_identity.identifier, "username", generate(:email), "firstname", "lastname")
    end

    it { is_expected.not_to be_success }
    it { expect(service_response.message).to eq("UserIdentity is invalid") }
    it { expect { service_response }.not_to create_audit_event }
    it { expect(service_response.payload.full_messages).to include("Identifier has already been taken") }
  end

  context 'when email is a duplicate' do
    let(:existing_user) { create(:user) }
    let(:provider_id) { :google }
    let(:args) { { code: "valid_code" } }

    before do
      setup_identity_provider Code0::Identities::Identity.new(provider_id, "identifier", "username", existing_user.email, "firstname", "lastname")
    end

    it_behaves_like 'invalid user', "User is invalid"
  end

end
