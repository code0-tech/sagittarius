# frozen_string_literal: true

# Mails about the lifecycle of a license.
#
# The license is passed as a snapshot of plain values rather than the record itself: by the time
# the mail is delivered the row is gone - that is what the mail is about.
class LicenseMailer < ApplicationMailer
  load_extension_views :ee

  # The react-email templates are complete mails.
  layout false

  def license_removed
    assign_common

    @licensee = params[:licensee]
    @plan = params[:plan]
    @license_period = params[:license_period]
    @removed_at = params[:removed_at].to_date.to_fs(:long)
    @dashboard_url = Sagittarius::Configuration.external_url

    mail(to: @user.email, subject: 'Your license was removed')
  end
end
