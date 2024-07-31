# frozen_string_literal: true

Rails.application.config.to_prepare do
  Tucana.require_protos(:internal)
end
