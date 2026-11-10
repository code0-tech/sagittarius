# frozen_string_literal: true

require 'rails_helper'

# EE licenses are installation-wide, so its claims have no namespace at all. Cloud requires one
# (see CLOUD::UsageLimitNotification), which is why these cannot run there.
RSpec.describe UsageLimitNotification, unless: Sagittarius::Extensions.cloud? do
  describe '.claim' do
    let(:cycle_start) { Date.current.beginning_of_month }

    def claim(usage_kind: :ai, notification_kind: :warning, cycle_start: self.cycle_start)
      described_class.claim(
        usage_kind: usage_kind,
        notification_kind: notification_kind,
        cycle_start: cycle_start
      )
    end

    it 'is claimed exactly once' do
      expect(claim).to be(true)
      expect(claim).to be(false)
      expect(described_class.count).to eq(1)
    end

    it 'claims each resource separately' do
      expect(claim(usage_kind: :ai)).to be(true)
      expect(claim(usage_kind: :workflow)).to be(true)
    end

    it 'claims the warning and the limit itself separately' do
      expect(claim(notification_kind: :warning)).to be(true)
      expect(claim(notification_kind: :reached)).to be(true)
    end

    it 'claims again in the next billing cycle' do
      expect(claim(cycle_start: cycle_start)).to be(true)
      expect(claim(cycle_start: cycle_start + 1.month)).to be(true)
    end
  end
end
