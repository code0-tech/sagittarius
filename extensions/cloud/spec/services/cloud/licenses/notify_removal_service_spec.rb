# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Licenses::NotifyRemovalService do
  subject(:service_response) { described_class.new(license).execute }

  let(:namespace) { create(:namespace) }
  let(:license) { create(:license, namespace: namespace, licensee: { company: 'Code0' }) }

  let(:namespace_administrator) { create(:user) }

  before do
    member = create(:namespace_member, namespace: namespace, user: namespace_administrator)
    role = create(:namespace_role, namespace: namespace)
    create(:namespace_role_ability, namespace_role: role, ability: :namespace_administrator)
    create(:namespace_member_role, role: role, member: member)
  end

  it { expect(described_class).to include_module(CLOUD::Licenses::NotifyRemovalService) }

  it_behaves_like 'sends an email' do
    let(:mailer_class) { LicenseMailer }
    let(:mail_method) { :license_removed }
    let(:mail_params) { hash_including(user: namespace_administrator, licensee: 'Code0') }
  end

  it 'leaves the installation administrators out of it' do
    create(:user, admin: true)
    mail_message = instance_double(ActionMailer::MessageDelivery, deliver_later: nil)
    mailer = instance_double(LicenseMailer, license_removed: mail_message)
    allow(LicenseMailer).to receive(:with).and_return(mailer)

    expect(service_response).to be_success
    expect(LicenseMailer).to have_received(:with).exactly(1).time
  end

  it 'still reaches them once the license row is gone' do
    mail_message = instance_double(ActionMailer::MessageDelivery, deliver_later: nil)
    mailer = instance_double(LicenseMailer, license_removed: mail_message)
    allow(LicenseMailer).to receive(:with).and_return(mailer)
    license.delete

    expect(service_response).to be_success
    expect(LicenseMailer).to have_received(:with).with(hash_including(user: namespace_administrator))
  end
end
