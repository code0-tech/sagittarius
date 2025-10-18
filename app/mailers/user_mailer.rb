# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def email_verification
    @user = params[:user]
    @verification_code = params[:verification_code]

    mail(to: @user.email, subject: 'Email verification')
  end

  def password_reset
    @user = params[:user]
    @verification_code = params[:verification_code]

    mail(to: @user.email, subject: 'Password reset')
  end
end
