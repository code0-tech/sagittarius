# frozen_string_literal: true

require 'digest'

# rubocop:disable-next Lint/RedundantDirGlobSort
Dir[File.join(__dir__, 'cop', '**', '*.rb')].sort.each { |file| require file }
