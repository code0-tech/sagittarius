# frozen_string_literal: true

class GuestUserMailer < ApplicationMailer
  load_extension_views :cloud

  def guest_user_created
    user = params[:user]

    @claim_token = user.generate_token_for(:guest_claim)

    mail(to: user.email, subject: 'Complete your account')
  end
end
