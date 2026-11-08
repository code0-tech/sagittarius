# frozen_string_literal: true

# One row per usage limit notification that has already gone out, so a warning or a
# limit-reached mail is sent once per billing cycle instead of once per recorded execution or
# generation (usage is enforced on every single one of those).
#
# A row is a claim, not a log: `claim` inserts it and reports whether this caller is the one
# that got to send the mail, which makes the dedupe race-safe across processes without a lock.
# That also makes the data transient - a past cycle's claims answer nothing - so the table is
# partitioned by cycle and old partitions are dropped rather than swept.
#
# Defined in the EE extension, like everything else about usage limits: core has no limits to
# notify about (see Namespaces::Usage::NotifyLimitsService).
class UsageLimitNotification < ApplicationRecord
  include Code0::ZeroTrack::Database::Partitioning::PartitionedTable

  # Which metered resource the notification was about.
  USAGE_KINDS = { ai: 0, workflow: 1 }.freeze
  # How far into the limit the scope was when it went out. A scope that crossed the warning
  # threshold and later the limit itself gets both, in that order.
  NOTIFICATION_KINDS = { warning: 0, reached: 1 }.freeze

  # One partition per month, keeping the current cycle and the couple before it. A cycle is a
  # month long, so anything older can no longer be claimed against.
  partition_by :cycle_start, strategy: :monthly, retain_for: 3.months

  self.table_name = 'p_usage_limit_notifications'
  self.primary_key = %i[id cycle_start]

  enum :usage_kind, USAGE_KINDS, prefix: :usage
  enum :notification_kind, NOTIFICATION_KINDS, prefix: :notification

  # nil namespace = installation-wide (EE), see the migration. optional: true because there is
  # no DB-level foreign key either - Cloud is the one that requires a namespace here (see
  # CLOUD::UsageLimitNotification).
  belongs_to :namespace, inverse_of: :usage_limit_notifications, optional: true

  validates :cycle_start, presence: true

  # true when this call inserted the row and therefore owns sending the mail, false when the
  # notification had already gone out for this scope, resource, kind and billing cycle.
  def self.claim(namespace:, usage_kind:, notification_kind:, cycle_start:)
    create!(
      namespace: namespace,
      usage_kind: usage_kind,
      notification_kind: notification_kind,
      cycle_start: cycle_start
    )

    true
  rescue ActiveRecord::RecordNotUnique
    false
  end
end

UsageLimitNotification.prepend_extensions
