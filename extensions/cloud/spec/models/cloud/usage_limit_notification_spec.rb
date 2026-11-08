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

  it 'is valid with a namespace' do
    notification = described_class.new(namespace: create(:namespace), usage_kind: :ai,
                                       notification_kind: :warning, cycle_start: Date.current.beginning_of_month)

    expect(notification).to be_valid
  end
end
