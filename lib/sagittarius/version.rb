# frozen_string_literal: true

module Sagittarius
  Version = File.read(File.expand_path('../../VERSION', __dir__)).strip.freeze
end
