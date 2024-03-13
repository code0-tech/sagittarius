# frozen_string_literal: true

require 'rails/code_statistics'

task stats: :code_stats

task code_stats: :environment do
  %w[Finders Graphql Policies Services].each_with_index do |type, i|
    STATS_DIRECTORIES.insert i + 5, [type, "app/#{type.downcase}"]
  end

  STATS_DIRECTORIES.insert 9, %w[Tooling tooling]
end
