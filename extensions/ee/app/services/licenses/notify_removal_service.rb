# frozen_string_literal: true

module Licenses
  # Tells the administrators that a license is gone. EE licenses are installation-wide, so the
  # installation's administrators are told; Cloud redirects that to the namespace's own
  # administrators (see CLOUD::Licenses::NotifyRemovalService).
  #
  # The record is already deleted when this runs - only the in-memory object is left - so it is
  # snapshotted into plain values right away rather than handed to the mailer.
  class NotifyRemovalService
    include Code0::ZeroTrack::Loggable

    attr_reader :license

    def initialize(license)
      @license = license
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

    protected

    # `protected`, not `private`, because Cloud overrides it (Sagittarius::Override verifies
    # with Module#method_defined?, which ignores private methods).
    def recipients
      ::User.notifiable.administrators
    end

    private

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

Licenses::NotifyRemovalService.prepend_extensions
