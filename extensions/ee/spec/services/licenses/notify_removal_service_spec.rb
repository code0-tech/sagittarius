# frozen_string_literal: true

require 'rails_helper'

# Cloud redirects the recipients to the license's namespace (see
# CLOUD::Licenses::NotifyRemovalService), so EE's installation-wide behavior - and the
# namespace-less license it needs - only exists where cloud is not active.
RSpec.describe Licenses::NotifyRemovalService, unless: Sagittarius::Extensions.cloud? do
  subject(:service_response) { described_class.new(license).execute }

  let(:license) do
    create(:license, licensee: { company: 'Code0' }, options: { plan: 'PRO' },
                     start_date: Date.new(2026, 1, 15), end_date: Date.new(2027, 1, 14))
  end

  let(:mailer) { instance_double(LicenseMailer) }
  let(:mail_message) { instance_double(ActionMailer::MessageDelivery, deliver_later: nil) }

  before do
    allow(LicenseMailer).to receive(:with).and_return(mailer)
    allow(mailer).to receive(:license_removed).and_return(mail_message)
  end

  context 'with an installation-wide license' do
    let!(:administrator) { create(:user, admin: true) }

    it 'mails the installation administrators' do
      expect(service_response).to be_success
      expect(LicenseMailer).to have_received(:with).with(hash_including(user: administrator))
      expect(mail_message).to have_received(:deliver_later)
    end

    it 'leaves regular users out of it' do
      create(:user)

      expect(service_response).to be_success
      expect(LicenseMailer).to have_received(:with).exactly(1).time
    end

    it 'snapshots the license before it is gone' do
      license.delete

      expect(service_response).to be_success
      expect(LicenseMailer).to have_received(:with).with(
        hash_including(
          licensee: 'Code0',
          plan: 'PRO',
          license_period: 'January 15, 2026 - January 14, 2027',
          removed_at: Date.current
        )
      )
    end

    context 'with a license that never expires' do
      let(:license) do
        create(:license, start_date: Date.new(2026, 1, 15), end_date: nil,
                         options: { allow_missing_end_date: true })
      end

      it 'says so instead of printing an empty period' do
        expect(service_response).to be_success
        expect(LicenseMailer).to have_received(:with).with(
          hash_including(license_period: 'January 15, 2026 - no end date')
        )
      end
    end

    context 'with a license carrying no plan' do
      let(:license) { create(:license, options: {}) }

      it 'falls back to a custom plan' do
        expect(service_response).to be_success
        expect(LicenseMailer).to have_received(:with).with(hash_including(plan: 'Custom'))
      end
    end
  end

  context 'when the notification cannot be enqueued' do
    before do
      create(:user, admin: true)
      allow(LicenseMailer).to receive(:with).and_raise(StandardError, 'nope')
    end

    it 'fails without taking the deletion down with it' do
      expect(service_response).to be_error
      expect(service_response.payload[:error_code]).to eq(:license_removal_notification_failed)
    end
  end
end
