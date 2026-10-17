# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def email_verification
    UserMailer.with(user: user, verification_code: user.generate_token_for(:email_verification)).email_verification
  end

  def password_reset
    UserMailer.with(user: user, verification_code: user.generate_token_for(:password_reset)).password_reset
  end

  private

  def user
    User.first || FactoryBot.create(:user)
  end
end
