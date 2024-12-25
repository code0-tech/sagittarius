# frozen_string_literal: true

Rails.application.config.to_prepare do
  require 'google/protobuf/well_known_types'
  Tucana.load_protocol(:sagittarius)
end
