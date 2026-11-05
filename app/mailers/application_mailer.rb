# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  # The product is written "CodeZero" in body copy; the legal entity behind it is only ever named
  # in the footer, where it has to be spelled out in full.
  COMPANY_NAME = 'CodeZero'
  LEGAL_NAME = 'Code0 UG (haftungsbeschränkt)'
  # Where a customer is told to write back. Deliberately not derived from the mailer's "from"
  # address: that one is the unattended sending identity (no-reply@...), so pointing a customer at
  # it tells them to reply into a mailbox nobody reads.
  SUPPORT_EMAIL = 'support@codezero.build'

  default from: Sagittarius::Configuration.config[:rails][:mailer][:from]
  layout 'mailer'

  def test_mail
    @user = params[:user]

    mail(to: @user.email, subject: 'Test mail')
  end

  def self.load_extension_views(extension)
    prepend_view_path Rails.root.join("extensions/#{extension}/app/views").to_s
  end

  private

  # Props every react-email template expects, straight from `params[:user]`.
  def assign_common
    @user = params[:user]
    @company_name = COMPANY_NAME
    @legal_name = LEGAL_NAME
    @user_name = @user.firstname.presence || @user.username
    @account_name = @user.username
    @email = @user.email
    @support_email = support_email
  end

  def support_email
    SUPPORT_EMAIL
  end
end
