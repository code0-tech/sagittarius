# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/license_mailer
class LicenseMailerPreview < ActionMailer::Preview
  def license_removed
    LicenseMailer.with(
      user: user,
      licensee: 'Code0',
      plan: 'PRO',
      license_period: "#{(Date.current - 1.year).to_fs(:long)} - #{(Date.current - 1.day).to_fs(:long)}",
      removed_at: Date.current
    ).license_removed
  end

  private

  def user
    User.first || FactoryBot.create(:user)
  end
end
