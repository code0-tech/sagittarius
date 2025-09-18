# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Sagittarius::Configuration.config[:rails][:mailer][:username]
  layout 'mailer'

  def test_mail
    @user = params[:user]

    mail(to: @user.email, subject: 'Test mail')
  end

  def password_reset_mail
    @user = params[:user]
    @verification_code = params[:verification_code]

    mail(to: @user.email, subject: 'Reset your password')
  end

  def email_verification_mail
    @user = params[:user]
    @verification_code = params[:verification_code]

    mail(to: @user.email, subject: 'Email verification')
  end

end
