# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class ApplicationMailerPreview < ActionMailer::Preview
  def test_mail
    user = User.first || FactoryBot.create(:user)
    ApplicationMailer.with(user: user).test_mail
  end
end
