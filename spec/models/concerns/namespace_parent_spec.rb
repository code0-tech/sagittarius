# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NamespaceParent do
  describe '#ensure_namespace', :disable_transaction do
    let!(:user) { create(:user) }
    let(:thread_count) { [ActiveRecord::Base.connection_pool.size - 1, 2].max }

    it 'creates exactly one namespace when called concurrently from separate connections' do
      barrier = Concurrent::CyclicBarrier.new(thread_count)

      results = Array.new(thread_count) do
        Thread.new do
          ActiveRecord::Base.connection_pool.with_connection do
            barrier.wait
            User.find(user.id).ensure_namespace
          end
        end
      end.map(&:value)

      expect(results).to all(be_a(Namespace))
      expect(results.map(&:id).uniq.size).to eq(1)
      expect(Namespace.where(parent: user).count).to eq(1)
    end
  end
end
