# frozen_string_literal: true

# rubocop:disable Lint/RedundantDirGlobSort
Dir[File.join(__dir__, 'cop', '**', '*.rb')].sort.each { |file| require file }
# rubocop:enable Lint/RedundantDirGlobSort
