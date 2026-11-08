# frozen_string_literal: true

module Licenses
  # Tells the administrators that a license is gone and what that costs them.
  #
  # Both delete paths use this one service and only differ in the scope they hand it: EE deletes
  # an installation-wide license (`namespace: nil`, so the installation's administrators are
  # notified), Cloud deletes a namespace's license (so that namespace's administrators are).
  # That is the whole difference, which is why this is a plain service rather than another
  # core/EE/Cloud override chain.
  #
  # Takes the license record it is told about and snapshots it immediately: the record is
  # already deleted by the time this runs - its row is gone, only the in-memory object with its
  # `data` is left - so nothing may be read off it later, in the mail template least of all.
  class NotifyRemovalService
    include Code0::ZeroTrack::Loggable

    attr_reader :license, :namespace

    # namespace: the namespace the license belonged to, or nil for an installation-wide one.
    def initialize(license, namespace: nil)
      @license = license
      @namespace = namespace
    end

    def execute
      recipients.each do |user|
        LicenseMailer.with(user: user, **snapshot).license_removed.deliver_later
      end

      ServiceResponse.success(message: 'License removal notifications enqueued')
    rescue StandardError => e
      # A license is deleted whether or not anyone could be told about it; failing the deletion
      # over an undeliverable mail would be the worse outcome.
      logger.error(message: 'Failed to enqueue license removal notifications',
                   license_id: license.id, error: e.message)

      ServiceResponse.error(message: 'Failed to enqueue license removal notifications',
                            error_code: :license_removal_notification_failed)
    end

    private

    def recipients
      return namespace.administrator_users.notifiable if namespace.present?

      ::User.notifiable.administrators
    end

    def snapshot
      {
        licensee: license.licensee_name || 'Unknown',
        plan: license.plan_name || 'Custom',
        license_period: license_period,
        removed_at: Date.current,
      }
    end

    # "15 January 2026 - 14 January 2027", or open-ended when the license never expired.
    def license_period
      from = license.start_date
      to = license.end_date

      return 'Unknown' if from.nil?
      return "#{format_date(from)} - no end date" if to.nil?

      "#{format_date(from)} - #{format_date(to)}"
    end

    def format_date(date)
      date.to_date.to_fs(:long)
    end
  end
end
