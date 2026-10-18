# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  COMPANY_NAME = 'Code0'

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
    @user_name = @user.firstname.presence || @user.username
    @account_name = @user.username
    @email = @user.email
    @support_email = support_email
    @logo_url = "#{Sagittarius::Configuration.external_url}/public/logo.svg"
  end

  def support_email
    Mail::Address.new(Sagittarius::Configuration.config.dig(:rails, :mailer, :from)).address
  end
end
