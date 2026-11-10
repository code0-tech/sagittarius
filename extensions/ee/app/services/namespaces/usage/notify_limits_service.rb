# frozen_string_literal: true

module Namespaces
  module Usage
    # Mails the administrators when a metered resource is about to run out, and again when it
    # has. Defined in the EE extension because usage limits are a licensing concern.
    #
    # EE licenses are installation-wide, so the usage pool measured here and the people notified
    # about it span the whole installation. Cloud narrows both to the namespace whose usage was
    # just recorded (see CLOUD::Namespaces::Usage::NotifyLimitsService).
    #
    # Called on every recorded generation and every reported batch of executions, so it stays
    # cheap when nothing is wrong: the usage sums are only queried once a limit actually exists.
    class NotifyLimitsService
      include Code0::ZeroTrack::Loggable
      include Code0::ZeroTrack::Memoize

      # Share of the limit at which the heads-up mail goes out.
      WARNING_RATIO = 0.8

      # The metered resources, in the order they appear in the mails.
      USAGE_KINDS = %i[ai workflow].freeze

      # Resource -> the license restriction that caps it.
      RESTRICTIONS = { ai: :ai_tokens, workflow: :workflow_executions }.freeze

      # Resource -> how it is named to a human.
      RESOURCE_NAMES = { ai: 'AI tokens', workflow: 'workflow executions' }.freeze

      attr_reader :namespace

      def initialize(namespace:)
        @namespace = namespace
      end

      def execute
        unless notify?
          return ServiceResponse.success(message: 'Usage limit notifications not applicable',
                                         payload: { notified: [] })
        end

        states = USAGE_KINDS.index_with { |usage_kind| state_for(usage_kind) }
        # Reached first: a resource that is over its limit is reported as such, never as a
        # warning, and the two mails stay independent of each other.
        notified = %i[reached warning].filter_map { |notification_kind| notify_of(notification_kind, states) }

        ServiceResponse.success(message: 'Usage limit notifications processed',
                                payload: { notified: notified })
      rescue StandardError => e
        # The callers are the usage recording paths - a notification that cannot be worked out
        # or enqueued must never cost them the usage they just recorded.
        logger.error(message: 'Failed to process usage limit notifications',
                     namespace_id: namespace&.id, error: e.message)

        ServiceResponse.error(message: 'Failed to process usage limit notifications',
                              error_code: :usage_limit_notification_failed)
      end

      protected

      # The methods below are `protected`, not `private`, because Cloud overrides several of
      # them (Sagittarius::Override's verification relies on Module#method_defined?, which
      # ignores private methods).

      # Memoized because the mails read the limits back per recipient, and every read of the
      # license is a query.
      def license
        memoize(:license) { License.current }
      end

      # EE without a license has nothing to report against: there is no plan whose limits could
      # be approached, and the installation is already unusable (every limit is a hard 0, see
      # EE::Namespaces::Projects::Flows::EnforceUsageLimitService). Cloud, whose unlicensed
      # namespaces run on real free-tier limits, notifies either way.
      def notify?
        license.present?
      end

      # nil means unlimited - nothing to warn about.
      def limit_for(usage_kind)
        restriction = RESTRICTIONS.fetch(usage_kind)
        return nil unless license&.restricted?(restriction)

        license.restrictions[restriction]
      end

      # What the claim rows are scoped to. EE claims installation-wide, matching its
      # installation-wide license; Cloud claims per namespace.
      def notification_scope
        {}
      end

      def cycle_anchor
        license&.start_date || Date.current.beginning_of_month
      end

      def ai_usage_relation
        AiUsageDailyAggregate.all
      end

      def workflow_usage_relation
        RuntimeUsageDailyAggregate.all
      end

      def recipients
        ::User.notifiable.administrators
      end

      private

      def cycle_range
        memoize(:cycle_range) { Sagittarius::BillingCycle.range_for(cycle_anchor) }
      end

      def reset_date
        memoize(:reset_date) { Sagittarius::BillingCycle.next_reset_date(cycle_anchor) }
      end

      # :reached, :warning, or nil when the resource is unlimited or comfortably within budget.
      def state_for(usage_kind)
        limit = limit_for(usage_kind)
        return nil if limit.nil?

        usage = usage_for(usage_kind)
        return :reached if usage >= limit
        return :warning if limit.positive? && usage >= limit * WARNING_RATIO

        nil
      end

      def usage_for(usage_kind)
        @usage_for ||= {}
        @usage_for[usage_kind] ||= case usage_kind
                                   when :ai then ai_usage_relation.where(date: cycle_range).sum(:total_usage)
                                   when :workflow
                                     workflow_usage_relation.where(date: cycle_range).sum(:execution_count)
                                   end
      end

      # Sends one mail covering every resource in this state, and only if at least one of them
      # had not been reported for this billing cycle yet. Returns the kind that went out, or
      # nil when nothing did.
      def notify_of(notification_kind, states)
        affected = states.select { |_, state| state == notification_kind }.keys
        return nil if affected.empty?

        claimed = affected.count { |usage_kind| claim(usage_kind, notification_kind) }
        return nil if claimed.zero?

        deliver(notification_kind, affected)

        notification_kind
      end

      def claim(usage_kind, notification_kind)
        UsageLimitNotification.claim(
          usage_kind: usage_kind,
          notification_kind: notification_kind,
          cycle_start: cycle_range.begin,
          **notification_scope
        )
      end

      def deliver(notification_kind, affected)
        recipients.each do |user|
          mailer = UsageLimitMailer.with(**mail_params(user, notification_kind, affected))

          case notification_kind
          when :reached then mailer.limit_reached.deliver_later
          when :warning then mailer.limit_warning.deliver_later
          end
        end
      end

      def mail_params(user, notification_kind, affected)
        params = {
          user: user,
          affected_resources: affected.map { |usage_kind| RESOURCE_NAMES.fetch(usage_kind) }.to_sentence,
          ai_usage: usage_for(:ai),
          ai_limit: limit_for(:ai),
          workflow_usage: usage_for(:workflow),
          workflow_limit: limit_for(:workflow),
          reset_date: reset_date,
        }
        params[:threshold_percentage] = (WARNING_RATIO * 100).round if notification_kind == :warning
        params
      end
    end
  end
end

Namespaces::Usage::NotifyLimitsService.prepend_extensions
