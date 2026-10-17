# frozen_string_literal: true

class UserMailer < ApplicationMailer
  COMPANY_NAME = 'Code0'

  # The react-email templates are complete mails. No layout necessary.
  layout false

  def email_verification
    assign_common
    @verification_url = "#{Sagittarius::Configuration.external_url}/email?code=#{CGI.escape(params[:verification_code])}"
    @link_expires_in = "#{User::EMAIL_VERIFICATION_TOKEN_EXPIRY.in_minutes.to_i} minutes"

    mail(to: @user.email, subject: 'Email verification')
  end

  def password_reset
    assign_common
    @reset_url = "#{Sagittarius::Configuration.external_url}/password/reset?code=#{CGI.escape(params[:verification_code])}"
    @link_expires_in = "#{User::PASSWORD_RESET_TOKEN_EXPIRY.in_minutes.to_i} minutes"

    mail(to: @user.email, subject: 'Password reset')
  end

  private

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
