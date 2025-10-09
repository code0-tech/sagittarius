# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Sagittarius::Configuration.config[:rails][:mailer][:from]
  layout 'mailer'

  def test_mail
    @user = params[:user]

    mail(to: @user.email, subject: 'Test mail')
  end
end
