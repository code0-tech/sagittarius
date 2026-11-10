# frozen_string_literal: true

# Usage limit mails for the metered resources (AI tokens, workflow executions).
#
# License-agnostic on purpose: every value shown is passed in by the caller (see
# Namespaces::Usage::NotifyLimitsService and its Cloud override), so the same mail serves EE's
# installation-wide limits, Cloud's per-namespace ones and the free tier.
#
# Both mails always show both meters, whichever one triggered them - `affected_resources` names
# that one. The exported ERB templates have one tag per value (see tooling/mails) and cannot drop
# a row conditionally anyway.
class UsageLimitMailer < ApplicationMailer
  # The react-email templates are complete mails.
  layout false

  def limit_reached
    assign_usage

    mail(to: @user.email, subject: "Usage limit reached for #{@affected_resources}")
  end

  def limit_warning
    assign_usage
    @threshold_percentage = "#{params[:threshold_percentage]}%"

    mail(to: @user.email, subject: "#{@threshold_percentage} of your #{@affected_resources} used")
  end

  private

  def assign_usage
    assign_common

    @affected_resources = params[:affected_resources]
    @ai_usage_summary = usage_summary(params[:ai_usage], params[:ai_limit])
    @workflow_usage_summary = usage_summary(params[:workflow_usage], params[:workflow_limit])
    @reset_date = params[:reset_date].to_date.to_fs(:long)
    @dashboard_url = Sagittarius::Configuration.external_url
  end

  # "24,500 of 25,000 (98%)", or "24,500 of unlimited" when the resource is not restricted.
  def usage_summary(usage, limit)
    used = number_with_delimiter(usage)
    return "#{used} of unlimited" if limit.nil?

    "#{used} of #{number_with_delimiter(limit)} (#{percentage_of(usage, limit)}%)"
  end

  # A limit of 0 (EE without a license) has no meaningful ratio.
  def percentage_of(usage, limit)
    return 100 if limit.zero?

    ((usage.to_f / limit) * 100).round
  end

  def number_with_delimiter(number)
    ActiveSupport::NumberHelper.number_to_delimited(number)
  end
end
