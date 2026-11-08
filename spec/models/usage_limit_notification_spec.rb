# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsageLimitNotification do
  describe '.claim' do
    let(:cycle_start) { Date.new(2026, 1, 15) }

    def claim(namespace: nil, usage_kind: :ai, notification_kind: :warning, cycle_start: self.cycle_start)
      described_class.claim(
        namespace: namespace,
        usage_kind: usage_kind,
        notification_kind: notification_kind,
        cycle_start: cycle_start
      )
    end

    it 'is claimed exactly once for the same installation-wide scope' do
      expect(claim).to be(true)
      expect(claim).to be(false)
      expect(described_class.count).to eq(1)
    end

    it 'is claimed exactly once for the same namespace' do
      namespace = create(:namespace)

      expect(claim(namespace: namespace)).to be(true)
      expect(claim(namespace: namespace)).to be(false)
    end

    it 'claims each namespace separately' do
      expect(claim(namespace: create(:namespace))).to be(true)
      expect(claim(namespace: create(:namespace))).to be(true)
    end

    it 'does not let a namespace claim consume the installation-wide one' do
      expect(claim(namespace: create(:namespace))).to be(true)
      expect(claim).to be(true)
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
