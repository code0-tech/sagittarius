# frozen_string_literal: true

RSpec.shared_examples 'sends an email' do
  let(:mailer_class) { nil }
  let(:mail_method) { nil }
  let(:mail_params) { nil }

  it do
    mailer = instance_double(mailer_class)
    mail_message = instance_double(ActionMailer::MessageDelivery)

    allow(mailer_class).to receive(:with).with(mail_params).and_return(mailer)
    allow(mailer).to receive(mail_method).and_return(mail_message)
    allow(mail_message).to receive(:deliver_later)

    subject

    expect(mail_message).to have_received(:deliver_later)
  end
end

RSpec.shared_examples 'sends no email' do
  let(:mailer_class) { nil }
  let(:mail_method) { nil }
  let(:mail_params) { nil }

  it do
    mailer = instance_double(mailer_class)
    mail_message = instance_double(ActionMailer::MessageDelivery)

    allow(mailer_class).to receive(:with).with(mail_params).and_return(mailer)
    allow(mailer).to receive(mail_method).and_return(mail_message)
    allow(mail_message).to receive(:deliver_later)

    subject

    expect(mail_message).not_to have_received(:deliver_later)
  end
end
