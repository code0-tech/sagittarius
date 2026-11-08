# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/usage_limit_mailer
class UsageLimitMailerPreview < ActionMailer::Preview
  def limit_reached
    UsageLimitMailer.with(**usage_params).limit_reached
  end

  def limit_warning
    UsageLimitMailer.with(**usage_params, threshold_percentage: 80).limit_warning
  end

  private

  # Plain values rather than a real license: the mailer is license-agnostic by design, so a
  # preview does not need the EE extension to be set up (see UsageLimitMailer).
  def usage_params
    {
      user: user,
      affected_resources: 'AI tokens and workflow executions',
      ai_usage: 25_000,
      ai_limit: 25_000,
      workflow_usage: 51,
      workflow_limit: 50,
      reset_date: Date.current + 1.month,
    }
  end

  def user
    User.first || FactoryBot.create(:user)
  end
end
