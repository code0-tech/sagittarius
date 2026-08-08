# frozen_string_literal: true

class PartitionManagerSyncJob < ApplicationJob
  def perform
    Code0::ZeroTrack::Database::Partitioning::PartitionManager.sync_all_partitions!
  end
end
