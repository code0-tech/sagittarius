# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Sagittarius::Configuration.config[:rails][:mailer][:username]
  layout 'mailer'

  def test_mail
    @user = params[:user]

    mail(to: @user.email, subject: 'Test mail') do |format|
      format.text { render plain: 'This is a test mail.' }
    end
  end
end
