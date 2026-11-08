# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsageLimitNotification do
  describe '.claim' do
    # Within the retained partitions (see the model) - a claim for a cycle whose partition has
    # already been dropped is not something the service can ever make.
    let(:cycle_start) { Date.current.beginning_of_month }

    def claim(namespace: nil, usage_kind: :ai, notification_kind: :warning, cycle_start: self.cycle_start)
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

    # EE's licenses are installation-wide, so its notifications have no namespace. Cloud
    # requires one (see CLOUD::UsageLimitNotification), which is why these cannot run there.
    context 'with an installation-wide claim', unless: Sagittarius::Extensions.cloud? do
      it 'is claimed exactly once' do
        expect(claim).to be(true)
        expect(claim).to be(false)
        expect(described_class.count).to eq(1)
      end

      it 'is not consumed by a namespace claim' do
        expect(claim(namespace: create(:namespace))).to be(true)
        expect(claim).to be(true)
      end
    end
  end
end
