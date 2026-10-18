# frozen_string_literal: true

class GuestUserMailer < ApplicationMailer
  load_extension_views :cloud

  # The react-email templates are complete mails. No layout necessary.
  layout false

  def guest_user_created
    assign_common
    claim_token = @user.generate_token_for(:guest_claim)
    @claim_url = "#{Sagittarius::Configuration.external_url}/guest/claim?code=#{CGI.escape(claim_token)}"

    mail(to: @user.email, subject: 'Complete your account')
  end
end
