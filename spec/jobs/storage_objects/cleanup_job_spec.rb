# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StorageObjects::CleanupJob do
  it 'reaps stale pending uploads' do
    stale = create(:storage_object, status: :pending, created_at: 2.days.ago)
    fresh = create(:storage_object, status: :pending)

    described_class.new.perform

    expect(StorageObject.exists?(stale.id)).to be(false)
    expect(StorageObject.exists?(fresh.id)).to be(true)
  end

  it 'reaps expired committed objects but keeps live ones' do
    expired = create(:storage_object, :committed, expires_at: 1.hour.ago)
    live = create(:storage_object, :committed, expires_at: 1.hour.from_now)
    permanent = create(:storage_object, :committed, expires_at: nil)

    described_class.new.perform

    expect(StorageObject.exists?(expired.id)).to be(false)
    expect(StorageObject.exists?(live.id)).to be(true)
    expect(StorageObject.exists?(permanent.id)).to be(true)
  end
end
