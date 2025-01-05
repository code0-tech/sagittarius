# frozen_string_literal: true

Rails.application.config.to_prepare do
  Tucana.load_protocol(:sagittarius)
end
