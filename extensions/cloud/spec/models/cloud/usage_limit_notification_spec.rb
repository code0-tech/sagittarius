# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsageLimitNotification do
  it { expect(described_class).to include_module(CLOUD::UsageLimitNotification) }

  it 'requires a namespace - every Cloud license belongs to one' do
    notification = described_class.new(usage_kind: :ai, notification_kind: :warning,
                                       cycle_start: Date.current.beginning_of_month)

    expect(notification).not_to be_valid
    expect(notification.errors[:namespace]).to be_present
  end

  describe '.claim' do
    let(:cycle_start) { Date.current.beginning_of_month }

    def claim(namespace:, usage_kind: :ai, notification_kind: :warning, cycle_start: self.cycle_start)
      described_class.claim(
        namespace: namespace,
        usage_kind: usage_kind,
        notification_kind: notification_kind,
        cycle_start: cycle_start
      )
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

    it 'claims each resource separately' do
      namespace = create(:namespace)

      expect(claim(namespace: namespace, usage_kind: :ai)).to be(true)
      expect(claim(namespace: namespace, usage_kind: :workflow)).to be(true)
    end

    it 'claims the warning and the limit itself separately' do
      namespace = create(:namespace)

      expect(claim(namespace: namespace, notification_kind: :warning)).to be(true)
      expect(claim(namespace: namespace, notification_kind: :reached)).to be(true)
    end

    it 'claims again in the next billing cycle' do
      namespace = create(:namespace)

      expect(claim(namespace: namespace, cycle_start: cycle_start)).to be(true)
      expect(claim(namespace: namespace, cycle_start: cycle_start + 1.month)).to be(true)
    end
  end
end
