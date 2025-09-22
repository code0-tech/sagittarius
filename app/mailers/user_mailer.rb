# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def email_verification
    @user = params[:user]
    @verification_code = params[:verification_code]

    mail(to: @user.email, subject: 'Email verification')
  end
end
