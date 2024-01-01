# frozen_string_literal: true

Rails.configuration.to_prepare do
  DeclarativePolicy.configure do
    named_policy :global, GlobalPolicy
  end
end
