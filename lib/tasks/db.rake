# frozen_string_literal: true

namespace :db do
  desc 'Sync partitions'
  task sync_partitions: :environment do
    Code0::ZeroTrack::Database::Partitioning::PartitionManager.sync_all_partitions!
  end

  Rake::Task['db:prepare'].enhance do
    Rake::Task['db:sync_partitions'].invoke
  end
end
