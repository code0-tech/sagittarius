# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/guest_user_mailer
class GuestUserMailerPreview < ActionMailer::Preview
  def guest_user_created
    GuestUserMailer.with(user: user).guest_user_created
  end

  private

  def user
    User.where(user_type: :guest).first || FactoryBot.create(:user, :guest)
  end
end
