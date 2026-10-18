# frozen_string_literal: true

class UserMailer < ApplicationMailer
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
end
