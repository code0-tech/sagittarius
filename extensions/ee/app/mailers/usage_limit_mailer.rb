# frozen_string_literal: true

# Usage limit mails for the metered resources (AI tokens, workflow executions).
#
# Deliberately license-agnostic: everything the templates show is passed in as a plain value by
# the caller (see Namespaces::Usage::NotifyLimitsService and its EE/Cloud overrides), so the
# same mail serves EE's installation-wide license limits and Cloud's per-namespace ones,
# free-tier limits included.
#
# Both mails always show both meters, even when only one of them triggered the notification: the
# other one is the context a recipient needs to judge the situation, and the react-email
# templates are exported to ERB with one tag per value (see tooling/mails), so a mail cannot
# conditionally drop a row anyway. Which resource(s) actually triggered it is named in
# `affected_resources`.
class UsageLimitMailer < ApplicationMailer
  # The react-email templates are complete mails. No layout necessary.
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

  # A limit of 0 (EE's "no license at all" case) has no meaningful ratio - any usage against it
  # is fully consumed.
  def percentage_of(usage, limit)
    return 100 if limit.zero?

    ((usage.to_f / limit) * 100).round
  end

  def number_with_delimiter(number)
    ActiveSupport::NumberHelper.number_to_delimited(number)
  end
end
